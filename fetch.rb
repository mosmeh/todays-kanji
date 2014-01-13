RSS_URI = 'http://news.google.com/news?hl=ja&ned=us&ie=UTF-8&oe=UTF-8&output=rss&num=50'
STORED_FILE = File.join(File.dirname(__FILE__), 'collected.db')

class Fetcher
  def initialize
    require 'rss'
  end

  def call
    rss = RSS::Parser.parse(RSS_URI)
    items = rss.items
    if File.exists?(STORED_FILE)
      stored = Marshal.load(File.read(STORED_FILE))
      latest = stored.max_by{|item| item.date}.date
      items = stored | items.select{|item| item.date > latest}
    end
    File.write(STORED_FILE, Marshal.dump(items))
  end
end
