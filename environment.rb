require 'bundler/setup'
require 'haml'
require 'active_record'
require 'mysql2'
require 'sinatra/flash'
require 'sass'
require 'yaml'
require 'will_paginate'
require 'will_paginate/active_record'
require 'i18n'
require 'pony'
require 'sinatra'

load 'config/settings.rb'
load 'data/lib/models.rb'
load 'data/lib/helpers.rb'

# i18n
I18n.locale = :en
I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'config', 'locales', '*.yml').to_s]