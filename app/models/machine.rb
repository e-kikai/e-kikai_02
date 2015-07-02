# == Schema Information
#
# Table name: machines
#
#  id             :integer          not null, primary key
#  no             :string
#  name           :string           not null
#  maker          :string
#  model          :string
#  year           :string
#  capacity       :float
#  location       :string
#  addr1          :string
#  addr2          :string
#  addr3          :string
#  spec           :text
#  accessory      :text
#  comment        :text
#  commission     :integer
#  genre_id       :integer          not null
#  company_id     :integer          not null
#  deleted_at     :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  machinelife_id :integer
#

class Machine < ActiveRecord::Base
  include Crawler

  serialize :machinelife_images

  belongs_to :company
  belongs_to :genre
  has_one    :middle_genre, :through => :genre
  has_one    :large_genre,  :through => :middle_genre
  has_many   :images, :as => :parent
  has_many   :contacts
  scope :list, -> { includes(:genre, :company, :middle_genre, :large_genre, :images).references(:genre, :company, :middle_genre, :large_genre, :images) }

  enum commission: {不可:'0' ,可:'1'}

  validates :name,       presence: true
  validates :genre_id,   presence: true
  validates :company_id, presence: true

  def commission_enum
    Machine.commissions
  end

  def self.search_list(q)
    list.search(q).result.order("machines.name, CASE WHEN maker IS NULL OR maker = '' THEN '1' ELSE '0' END, maker DESC, CASE WHEN model = '' THEN '1' ELSE '0' END, model")
  end

  def self.search_names(q)
    list.search(q).result.order("large_genres.order_no, middle_genres.order_no, genres.order_no, capacity IS NULL, capacity, machines.name").pluck(:name).uniq
  end

  def self.search_addr(q)
    list.search(q.reject{|k, v| k == "addr1_eq"}).result.group("machines.addr1").order("count_machines_addr1 DESC").count("machines.addr1").keys.reject(&:blank?)
  end

  def self.crawl
    Company.where.not(machinelife_id: nil).each do |c|
      puts c.name
      datas = self.get_datas("t=machines&c=#{c.machinelife_id}")
      return if datas.blank?

      machinelife_ids = c.machines.pluck(:machinelife_id)

      # データの整形
      datas.each do |d|
        begin
          genre_id = Genre.find_by(machinelife_id: d["genre_id"]).id

          machine = c.machines.find_or_create_by(:machinelife_id => d["id"])

          # 名前整形
          if d['capacity_unit'].present? && d['capacity'].present? && /^[0-9]/ !~ d['name']
            d['name'] = d['capacity'].to_s + d['capacity_unit'].to_s + d['name'];
          end

          # 画像配列整形
          imgs = (d["imgs"].kind_of? Hash) ? d["imgs"].values : Array(d["imgs"])
          imgs.unshift(d["top_img"]).reject!(&:blank?)

          machine.update({
            no:         d["no"],
            name:       d["name"],
            maker:      d["maker_master"].presence || d["maker"],
            model:      d["model"],
            year:       d["year"],
            capacity:   d["capacity"],
            location:   d["location"],
            addr1:      d["addr1"],
            addr2:      d["addr2"],
            addr3:      d["addr3"],
            spec:       d["spec"],
            accessory:  d["accessory"],
            comment:    d["comment"],
            commission: d["commission"].to_s,
            genre_id:   genre_id,
            company_id: c.id,
            machinelife_images: imgs,
          })

          puts machine[:machinelife_images]

          machinelife_ids.delete(d["id"])

          # 画像保存
          # imgs.each do |i|
          #   begin
          #     p i
          #     if image = machine.images.find_by(img_name: i)
          #       next
          #       content_length = open("#{MACHINE_IMG_URL}/#{i}").meta["content-length"].to_i
          #       next if content_length == image.img.size
          #     else
          #       image = machine.images.build
          #     end
          #
          #     p "#{MACHINE_IMG_URL}/#{i}"
          #     image.img_url = "#{MACHINE_IMG_URL}/#{i}"
          #     image.save
          #   rescue => e
          #     p e.message
          #     next
          #   end
          # end
          # puts machine.images.where.not(img_name: imgs).delete_all

        rescue => e
          puts e.message
          puts "#{d["genre_id"]} | #{d["name"]} #{d["maker"]} #{d["model"]} | #{d["company"]}"
          next
        end
      end

      # 1件でも更新されていれば、削除
      if machinelife_ids.present?
        puts c.machines.where(machinelife_id: machinelife_ids).delete_all
      end
    end
  rescue => e
    puts e.message
    puts $@
  end

  def self.crawl_ota
    ota = Company.find_by(machinelife_id: 235)
    puts ota.name

    machinelife_ids = ota.machines.pluck(:machinelife_id)

    # 初期化
    agent = Mechanize.new
    agent.max_history = 1
    urls = ['http://www.otakikai.co.jp/hs/mod/cart/index.php']
    histories = []

    defalut_genre_id = Genre.find_by(machinelife_id: 390).id
    trs = {"商品名" => :name, "管理番号" => :no, "型番" => :model, "メーカー名" => :maker,
      "所在地" => :location, "年式" => :year, "仕様" => :spec, "付属品" => :accessory}

    urls.each do |url|
      puts url
      page = agent.get url

      page.links.each do |link|
        href = URI.join(url, link.href).to_s
        if /mode=detail&article=([0-9]*)/ =~ href
          # スクレイピング処理
          machinelife_id = $1

          next if histories.include? href
          histories << href

          detail = link.click

          machine = ota.machines.find_or_create_by(:machinelife_id => machinelife_id)

          detail.search("#Right table tr").each do |tr|
            th = tr.search('th').text.strip
            td = tr.search('td').text.strip

            machine[trs[th]] = td if trs.include? th
          end

          # 名前整形
          if /^([0-9]+)t(.*)$/i =~ machine.name
            machine.capacity = $1
            machine.name     = "#{$1}T#{$2}"
          end

          # ジャンル整形
          hint =
            if    /パワープレス/ =~ machine.name then "電動C型プレス"
            elsif /油圧プレス/   =~ machine.name then "油圧プレス"
            elsif /タッピング/   =~ machine.name then "タッピング盤"
            elsif /コンプレッサ/ =~ machine.name then "エアーコンプレッサー"
            elsif /シャー/       =~ machine.name then "シャーリング"
            else                                     machine.name
            end

          machine.genre_id = if genre = Genre.find_by("name": hint)
            genre.id
          elsif temp  = Machine.find_by("name": hint)
            temp.genre.id
          elsif machine.model && temp = Machine.find_by("model": machine.model)
            temp.genre.id
          else
            defalut_genre_id
          end

          machine.company_id = ota.id
          if machine.location == "日本"
            machine.addr1 = "静岡県"
            machine.addr2 = "浜松市"
            machine.addr3 = "東区有玉北a町735"
          end

          # puts machine.attributes
          machine.save
          puts machine.attributes

          machinelife_ids.delete(machinelife_id)

          # 画像保存
          detail.search("#Left a img").each do |img|
            begin
              src = URI.join(url, img[:src]).to_s

              /^.*\/(.*?)$/ =~ src

              next if $1 == "underconstrunction.gif"
              puts $1

              next if image = machine.images.find_by(img_name: $1)

              image = machine.images.build
              image.img_url = src
              image.save
            rescue => e
              p e.message
              next
            end
          end
          # puts machine.images.where.not(img_name: imgs).delete_all
        elsif /index.php\?\&page=[0-9]*/ =~ href
          # クロール先に追加
          urls << href unless urls.include? href
        end
      end
    end

    # 1件でも更新されていれば、削除
    if machinelife_ids.present?
      # puts ota.machines.where(machinelife_id: machinelife_ids).delete_all
    end
  rescue => e
    puts e.message
    puts $@
  end

  def self.scrape_ota page, machinelife_id
    # genre_id = Genre.find_by(machinelife_id: 390).id
    # machine  = c.machines.find_or_create_by(:machinelife_id => machinelife_id)
    #
    # machine.update({
    #   no:         detail.search("#Right table tr:nth(2) td").text,
    #   name:       detail.search("#Right table tr:nth(1) td").text,
    #   maker:      detail.search("#Right table tr:nth(5) td").text,
    #   model:      detail.search("#Right table tr:nth(4) td").text,
    #   year:       nil,
    #   location:   detail.search("#Right table tr:nth(6) td").text,
    #   # addr1:      d["addr1"],
    #   # addr2:      d["addr2"],
    #   # addr3:      d["addr3"],
    #   spec:       detail.search("#Right table tr:nth(7) td").text,
    #   accessory:  detail.search("#Right table tr:nth(8) td").text,
    #   genre_id:   genre_id,
    #   company_id: ota.id,
    # })

    # 画像保存
    # imgs.each do |i|
    #   begin
    #     p i
    #     if image = machine.images.find_by(img_name: i)
    #       next
    #       content_length = open("#{MACHINE_IMG_URL}/#{i}").meta["content-length"].to_i
    #       next if content_length == image.img.size
    #     else
    #       image = machine.images.build
    #     end
    #
    #     p "#{MACHINE_IMG_URL}/#{i}"
    #     image.img_url = "#{MACHINE_IMG_URL}/#{i}"
    #     image.save
    #   rescue => e
    #     p e.message
    #     next
    #   end
    # end
    # puts machine.images.where.not(img_name: imgs).delete_all

    @machinelife_ids.delete(machinelife_id)
  rescue => e
    puts e.message
    # puts "#{d["genre_id"]} | #{d["name"]} #{d["maker"]} #{d["model"]} | #{d["company"]}"
  end
end
