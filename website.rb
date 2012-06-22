require "bundler/setup"
require 'sinatra'
require 'haml'
require 'active_record'
require 'mysql2'
require 'sinatra/flash'
require 'sass'
require 'yaml'
require 'will_paginate'
require 'will_paginate/active_record'
require 'i18n'

############ config database

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
 
############ i18n

I18n.locale = :es
I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'config', 'locales', '*.yml').to_s]

############ models

load 'data/lib/models.rb'

############ helpers

load 'data/lib/helpers.rb'

############ actions
 
enable :sessions 

get '/css/style.css' do
   sass :style
end
 
get '/' do  
  @users=User.all
  @contents=Content.new
  @contents=Content.paginate(:order => "created_at desc", :page => params[:page], :per_page => 10)

  haml :index
end

get '/about' do
  @user=User.find(1) #shame on me
  haml :about  
end

get '/about/edit' do
  require_login
  @user=User.find(session[:id])
  haml :about_edit  
end

post '/about/edit/:id' do
  user=User.find(params[:user][:id])
  user.about=params[:user][:about] 
  if user.save
    redirect_with_notice_message '/about', 'Successuflly edited information about yourself!'
  else
    flash[:error] = "Something's wrong!"
  end
end

get '/login' do
    require_login
    haml :login,
    :layout => false
end

post '/login' do
  if authenticate params[:username], params[:password]
    redirect '/'
  else
    redirect_with_error_message '/', 'Email or password wrong. Please try again'
  end
end

get '/posts' do
    require_login
    @contents=Content.new
    @contents=Content.paginate(:order => "created_at desc", :page => params[:page], :per_page => 10)
    
    haml :posts
end

get '/posts/delete/:id' do
  require_login
  Content.find(params[:id]).destroy
  redirect '/posts'
end

get '/posts/edit/:id' do
  require_login
  @content=Content.find(params[:id])
  haml :edit
end

get '/posts/add' do
  require_login
  @content=Content.new
  haml :add
end

post '/posts/add' do
  content=Content.create(params[:post])
  if content.save
    redirect_with_notice_message '/posts', 'Successuflly added Post!'
  else
    flash[:error] = "You've forgot to add title or content :)"
  end
end

post '/posts/edit/:id' do
  post = Content.find(params[:id])
  post.title = params[:post][:title] 
  post.text = params[:post][:text]
  if post.save
    redirect_with_notice_message '/posts', 'Successuflly edited Post!'
  else
    flash[:error] = "You've forgot to add title or content :)"
  end
end

get '/posts/show/:id' do
  require_login
  @content=Content.find(params[:id])
  haml :show
end

get '/profile' do
   require_login
   @user=User.find(session[:id])
   haml :profile
end

post '/profile_update' do
   if check_profile_passwords(params[:user][:password],params[:user][:rpassword])
      redirect '/profile'
   else
      redirect_with_error_message '/profile', 'Error!'
   end
end

get '/secret' do
   require_login
   haml :secret
end

get '/test' do
   require_login
   @coutries=Country.is_enabled
   @cities=City.related_with_country
   haml :some_page
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/*' do
  "ERROR404"
end

error do redirect '/' end