require 'pg'
require 'active_record'
require 'yaml'

ActiveRecord::Base.configurations = YAML.load_file(File.join(File.dirname(__FILE__), 'database.yml'))
ActiveRecord::Base.establish_connection(ENV['ENV'] || setting.environment)

class Day < ActiveRecord::Base
  has_many :kanjis
end

class Kanji < ActiveRecord::Base;
  belongs_to :day
end
