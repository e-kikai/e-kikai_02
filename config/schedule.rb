# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# 出力先のログファイルの指定
set :output, 'log/crontab.log'

# 事故防止の為RAILS_ENVの指定が無い場合にはdevelopmentを使用する
rails_env = ENV['RAILS_ENV'] || :development

set :environment, rails_env

# 2時間毎に実行するスケジューリング
# every " 5 2 * * * " do
#   runner "Machine.crawl"
# end

# every " 0 2 * * * " do
#   runner "Machine.crawl_ota"
# end

# sitemap
every 1.day, at: '5:00 am' do
  rake '-s sitemap:refresh'
end
