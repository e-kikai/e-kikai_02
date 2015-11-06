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
  belongs_to :image
  has_one    :middle_genre, :through => :genre
  has_one    :large_genre,  :through => :middle_genre
  has_many   :images, :as => :parent
  has_many   :contacts

  scope :list, -> { includes(:genre, :company, :middle_genre, :large_genre, :image) }

  enum commission: {不可:'0' ,可:'1'}

  validates :name,       presence: true
  validates :genre_id,   presence: true
  validates :company_id, presence: true

  def commission_enum
    Machine.commissions
  end

  def self.search_list(q)
    list.search(q).result.order("machines.name, CASE WHEN maker_kana IS NULL OR maker_kana = '' THEN '1' ELSE '0' END, maker_kana, CASE WHEN maker IS NULL OR maker = '' THEN '1' ELSE '0' END, maker, CASE WHEN model = '' THEN '1' ELSE '0' END, model")
  end

  def self.search_names(q)
    includes(:large_genre).search(q).result.order("large_genres.order_no, middle_genres.order_no, genres.order_no, capacity IS NULL, capacity, machines.name").pluck(:name).uniq
  end

  def self.crawl
    Company.where.not(machinelife_id: nil).order(:id).each do |c|
      puts "<< #{c.name} >>"
      begin
        datas = self.get_datas("t=machines&c=#{c.machinelife_id}")
      rescue => e
        puts e.message
        next
      end
      next if datas.blank?

      machinelife_ids = c.machines.pluck(:machinelife_id)
      numbers, deleted = 0

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
          # imgs = (d["imgs"].kind_of? Hash) ? d["imgs"].values : Array(d["imgs"])
          imgs = d["imgs"].try(:values) || Array(d["imgs"])
          imgs.unshift(d["top_img"]).reject!(&:blank?)

          machine.update({
            no:         d["no"],
            name:       d["name"],
            maker:      d["maker_master"].presence || d["maker"],
            maker_kana: d["maker_master_kana"],
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
          numbers += 1

          # puts machine[:machinelife_images]
          # puts "OK #{d["genre_id"]} | #{d["name"]} #{d["maker"]} #{d["model"]} | #{d["company"]}"

          machinelife_ids.delete(d["id"])

        rescue => e
          puts e.message
          puts "#{d["genre_id"]} | #{d["name"]} #{d["maker"]} #{d["model"]} | #{d["company"]}"
          next
        end
      end

      # 1件でも更新されていれば、更新されていないものを削除
      deleted = c.machines.where(machinelife_id: machinelife_ids).delete_all if numbers

      puts ">>>>> finish numbers: #{numbers} / deleted: #{deleted}"
    end
  rescue => e
    puts e.message
    puts $@
  end

  def self.crawl_ota
    ota = Company.find_by(machinelife_id: 235)
    puts "<< #{ota.name} >>"

    machinelife_ids = ota.machines.pluck(:machinelife_id)
    numbers, deleted = 0

    # 初期化
    agent = Mechanize.new
    agent.max_history = 1
    urls = ['http://www.otakikai.co.jp/hs/mod/cart/index.php']
    histories = []

    # ジャンル初期化
    genres           = Genre.pluck(:name, :id).to_h
    defalut_genre_id = Genre.order("order_no DESC").first.id

    trs = {
      "商品名"     => :name,
      "管理番号"   => :no,
      "型番"       => :model,
      "メーカー名" => :maker,
      "所在地"     => :location,
      "年式"       => :year,
      "仕様"       => :spec,
      "付属品"     => :accessory
    }

    urls.each do |url|
      puts url
      page = agent.get url

      page.links.each do |link|
        href = URI.join(url, link.href).to_s
        if /mode=detail&article=([0-9]*)/ =~ href
          # スクレイピング処理
          machinelife_id = $1.to_i

          next if histories.include? href
          histories << href

          detail = link.click

          machine = ota.machines.find_or_create_by(:machinelife_id => machinelife_id)

          detail.search("#Right table tr").each do |tr|
            th = tr.search('th').text.strip
            td = tr.search('td').text.strip

            machine[trs[th]] = td if trs.include? th
          end

          # データ整形
          machine.name, hint, machine.capacity = begin
            case machine.name
            when /([0-9.]+)t.*油圧プレス/i
              ["#{$1}T油圧プレス", "油圧プレス", $1]
            when /([0-9.]+)t.*(ストレートサイド)プレス/i
                ["#{$1}Tプレス", "電動門型プレス", $1]
            when /([0-9.]+)t(パワー|ワイド|トランスファー)?プレス/i
              ["#{$1}Tプレス", "電動C型プレス", $1]
            when /卓上プレス/
              ["卓上プレス", "電動C型プレス"]
            when "シャー"
              ["シャーリング", "メカシャーリング"]
            when /立.*フライス/
              ["立フライス", "立フライス"]
            when /万能.*フライス/
              ["万能フライス", "万能フライス"]
            when /コンプレッサ/
              [machine.name, "エアーコンプレッサー"]
            else
              [machine.name, machine.name]
            end
          end

          # # ジャンル整形
          machine.genre_id = if genres[hint].present?
            genres[hint]
          elsif temp = Machine.where.not(company_id: ota.id).find_by(name: hint)
            temp.genre.id
          elsif machine.model.present? && temp = Machine.where.not(company_id: ota.id).find_by(model: machine.model)
            temp.genre.id
          else
            defalut_genre_id
          end

          # メーカー整形
          machine.maker_kana = if /^[ァ-ヾ]+$/ =~ machine.maker
            machine.maker
          elsif temp = Machine.where.not(company_id: ota.id).find_by(maker: machine.maker)
            temp.maker_kana
          end

          machine.company_id = ota.id
          if machine.location == "日本"
            machine.addr1 = "静岡県"
            machine.addr2 = "浜松市"
            machine.addr3 = "東区有玉北町735"
          else
            machine.addr1 = machine.location
          end

          # puts machine.attributes
          machine.save
          numbers += 1

          machinelife_ids.delete(machinelife_id)

          # 画像保存
          top_img = nil
          detail.search("#Left a img").each do |img|
            begin
              src = URI.join(url, img[:src]).to_s
              /^.*\/(.*?)$/ =~ src

              next if $1 == "underconstrunction.gif"
              puts $1

              # 画像保存
              unless image = machine.images.find_by(img_name: $1)
                image = machine.images.build
                image.img_url = src
                image.save
              end

              if !top_img
                top_img = image.id
                machine.image_id = top_img
                machine.save
              end
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

    # 1件でも更新されていれば、更新されていないものを削除
    deleted = ota.machines.where(machinelife_id: machinelife_ids).delete_all if numbers

    puts ">>>>> finish numbers: #{numbers} / deleted: #{deleted}"
  rescue => e
    puts e.message
    puts $@
  end
end
