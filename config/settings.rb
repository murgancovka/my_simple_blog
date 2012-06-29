configure do
  ROOT = ::File.dirname(__FILE__)
  require 'erb'
  @db_settings = YAML::load(ERB.new(IO.read("config/database.yml")).result)
end

configure :development do
  set :environment, :development
  ActiveRecord::Base.establish_connection @db_settings['development']
end

configure :production do
  set :environment, :production
  ActiveRecord::Base.establish_connection @db_settings['production']
end
