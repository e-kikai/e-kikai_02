module Ahoy
  class Event < ActiveRecord::Base
    self.table_name = "ahoy_events"

    belongs_to :visit
    belongs_to :user

    serialize :properties, JSON

    scope :select_interval, -> { select("*", 'EXTRACT(EPOCH from (lead(TIME) OVER (PARTITION BY visit_id)) - TIME)  AS interval') }

    scope :interval_day, -> (days) { where('time > ?', Date.today.days_ago(days.to_i)) }

    def self.ml_events(days=7)
      includes(:visit).interval_day(days).select_interval
    end
  end
end
