class Visit < ActiveRecord::Base
  has_many :ahoy_events, class_name: "Ahoy::Event"
  belongs_to :user

  # 訪問者情報を取得
  def self.ml_visitors(days=7)
    events   = Ahoy::Event.ml_events(days)
    visitors = Hash.new { |h,k| h[k] =  {region: ""} }

    ### イベントから訪問者属性を取得 ###
    events.each do |e|
      next unless e.visit && visitor_token = e.visit.visitor_token

      visitors[visitor_token] = { region: e.visit.region } if visitors[visitor_token].blank?
    end

    visitors
  end

  # 機械IDの取得
  def self.ml_machines(days=7)
    events  = Ahoy::Event.ml_events(days)
    machine_ids = []

    ### 必要な機械ID取得 ###
    events.each do |e|
      case
      when e.name == "contact" # 問合せ
        machine_ids << e.properties["id"] if e.properties["id"]
      when e.properties["path"] =~ /search/ # 検索結果
        next unless e.properties["machine_ids"]
        e.properties["machine_ids"].each do |i|
          machine_ids << i
        end
      when e.properties["path"] =~ /detail\/([0-9]+)/ # 詳細ページ
        machine_ids << $1.to_i if $1.to_i
      end
    end
  end

  def self.ml_ratings(days=7)
    events  = Ahoy::Event.ml_events(days)
    ratings = Hash.new { |h,k| h[k] =  {visit: 0, interval: 0, contact: false, rating: 0} }


    ### イベントからレーティング基準値(アクセス時間、アクセス回数、問合せ)取得 ###
    events.each do |e|
      interval = e.interval || 0
      next unless e.visit && visitor_token = e.visit.visitor_token

      case
      when e.name == "contact" # 問合せ
        next unless machine_id = e.properties["id"]
        ratings[[visitor_token, machine_id]][:contact] = true

      when e.properties["path"] =~ /search/ # 検索結果
        next unless e.properties["machine_ids"]
        e.properties["machine_ids"].each do |i|
          ratings[[visitor_token, i]][:visit]    += 0.1
          ratings[[visitor_token, i]][:interval] += interval * 0.1
        end
      when e.properties["path"] =~ /detail\/([0-9]+)/ # 詳細ページ
        machine_id = $1.to_i
        ratings[[visitor_token, machine_id]][:visit]    += 1
        ratings[[visitor_token, machine_id]][:interval] += interval
      end
    end

    ### machines ###
    machines  = Machine.where(id: ratings.map { |k, v| k[1] }.uniq)
    machine_ids = machines.map { |v| v.id }

    ### レーティング値算出 ###
    ratings.each do |k, v|
      next unless machine_ids.include? k[1] # 削除された機械情報分を除外

      contact_rate = v[:contact] ? 5 : 0

      interval_rate = case v[:interval]
      when 0...60    then 1
      when 60...120  then 2
      when 120...180 then 3
      when 180...240 then 4
      else 5
      end

      visit_rate = case v[:visit]
      when 0..2  then 1
      when 2..5  then 2
      when 5..8  then 3
      when 8..10 then 4
      else 5
      end

      ratings[k][:rating] = contact_rate + interval_rate + visit_rate
    end

    ratings
  end
end
