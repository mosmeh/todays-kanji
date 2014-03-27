STORED_FILE = File.join(File.dirname(__FILE__), 'collected.db')

class Aggregater
  def initialize
    require 'rss'
    require 'date'
    require File.join(File.dirname(__FILE__), 'database.rb')
  end

  def call
    if File.exists?(STORED_FILE)
      items = Marshal.load(File.read(STORED_FILE))

      text_only_kanjis = ''
      items.each{|item| text_only_kanjis << item.description.gsub(/[^\u4e00-\u9fcf]/, '')} #remove non-chenese characters

      counts_of_kanjis = text_only_kanjis.split(//)
                                      .group_by{|x| x}
                                      .inject({}){|hash, (k, v)| hash[k] = v.length; hash}

      all = Kanji.find_or_create_by(kanji: 0)
      all.update_attribute(:count, all.count + text_only_kanjis.length)

      today = Day.new(date: Date.today, todays_kanji: nil)

      counts_of_kanjis.each do |kanji, count|
        kanji_all_terms = Kanji.find_or_create_by(kanji: kanji.ord)

        frequency = Float(count) / text_only_kanjis.length
        importance = Math.log(all.count / (kanji_all_terms.count + 0.1))
        score = frequency * importance

        kanji_all_terms.update_attributes(count: kanji_all_terms.count + count, score: kanji_all_terms.score + score)

        kanji_today = today.kanjis.build(kanji: kanji.ord, count: count, score: score)
      end

      today.save

      top_score = today.kanjis.order(score: :asc).first
      today.update_attribute(:todays_kanji, top_score.kanji)

      File.delete(STORED_FILE)
    end
  end
end
