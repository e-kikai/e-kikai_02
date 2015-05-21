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

  belongs_to :company
  belongs_to :genre
  has_one    :middle_genre, :through => :genre
  has_one    :large_genre,  :through => :middle_genre
  has_many   :images, :as => :parent
  has_many   :contacts
  scope :list, -> { includes(:genre, :company, :middle_genre, :large_genre).references(:genre, :company, :middle_genre, :large_genre) }

  enum commission: {不可:'0' ,可:'1'}

  validates :name,       presence: true
  validates :genre_id,   presence: true
  validates :company_id, presence: true

  def commission_enum
    Machine.commissions
  end

  def self.search_list(q)
    machines = list.search(q).result(distinct: true)
      .order("large_genres.order_no, middle_genres.order_no, genres.order_no, capacity, machines.name, maker, model")
  end

  def self.crawl
    Company.where.not(machinelife_id: nil).each do |c|
      datas = self.get_datas("t=machines&c=#{c.machinelife_id}")

      machinelife_ids = c.machines.pluck(:machinelife_id)

      # データの整形
      datas.each do |d|
        begin
          genre_id = Genre.find_by(machinelife_id: d["genre_id"]).id

          machine = c.machines.find_or_create_by(:machinelife_id => d["id"])
          machine.update({
            name:       d["name"],
            maker:      d["maker"],
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
          })

          machinelife_ids.delete(d["id"])

          imgs = (d["imgs"].kind_of? Hash) ? d["imgs"].values : Array(d["imgs"])
          imgs.unshift(d["top_img"]).reject!(&:blank?)

          # 画像保存
          next
          imgs.each do |i|
            begin
              p i
              if image = machine.images.find_by(img_name: i)
                next
                content_length = open("#{MACHINE_IMG_URL}/#{i}").meta["content-length"].to_i
                next if content_length == image.img.size
              else
                image = machine.images.build
              end

              p "#{MACHINE_IMG_URL}/#{i}"
              image.img_url = "#{MACHINE_IMG_URL}/#{i}"
              image.save
            rescue => e
              p e.message
              next
            end
          end
          puts machine.images.where.not(img_name: imgs).delete_all

        rescue => e
          p e.message
          next
        end
      end

      # 1件でも更新されていれば、削除
      if machinelife_ids.present?
        puts c.machines.where(machinelife_id: machinelife_ids).delete_all
      end
    end
  end
end
