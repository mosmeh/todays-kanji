require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'date'
require 'rufus/scheduler'

require File.join(File.dirname(__FILE__), 'database.rb')
require File.join(File.dirname(__FILE__), 'fetch.rb')
require File.join(File.dirname(__FILE__), 'aggregate.rb')

scheduler = Rufus::Scheduler.new
scheduler.every('2h', Fetcher.new)
scheduler.cron('0 0 * * *', Aggregater.new)

get '/' do
  day = Day.find_by(date: Date.today)
  day ||= Day.find_by(date: Date.today - 1)

  if day.nil?
    'not found'
  else
    @todays_kanji = day.todays_kanji.chr(Encoding::UTF_8)
    haml :index
  end
end
