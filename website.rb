require 'bundler/setup'
require 'sinatra'
require File.join(File.dirname(__FILE__), 'environment')

########### Project
 
enable :sessions

get '/css/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :"css/#{params[:name]}"
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

post '/search' do
  @contents=Content.search params[:content]
  haml :search
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
    @contents=Content.paginate(:order => "created_at desc", :page => params[:page], :per_page => 20)
    
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
  if params[:publish]
    content=Content.create(params[:post])
    content.is_enabled=true
    if content.save
      redirect_with_notice_message '/posts', 'Successuflly added Post!'
    else
      flash[:error] = get_model_errors(content)
    end
  else
    content=Content.create(params[:post])
    content.is_enabled=false
    if content.save
      redirect_with_notice_message '/posts', 'Successuflly added post to draft!'
    end
  end
end

post '/posts/edit/:id' do
  post=Content.find(params[:id])
  post.title=params[:post][:title] 
  post.text=params[:post][:text]
  
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

get '/posts/show_public/:id' do
  @content=Content.find(params[:id])
  haml :show_public
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

get '/contact' do
  haml :contact
end

post '/contact' do  
    
  name = params[:name]
  mail = params[:mail]
  body = params[:body]
  
  options = {
    :to => "hello@estof.net",
    :from => "madgamer@ot.ee",
    :subject=> "Contact Form",
    :body => "Body: #{params[:body]}",
    :via => :smtp,
    :via_options => {
      :address => 'smtp.gmail.com',
      :port => '587',
      :user_name => 'vitalizakharoff@gmail.com',
      :password => 'fAn1337!',
      :authentication => :plain,
      :domain => "gmail.com"
     },
    :headers => { "Reply-To" => params[:mail] }
     
  }

  Pony.mail(options)
    
  redirect_with_notice_message '/contact', 'Message successuflly sent!'
end


get '/logout' do
  session.clear
  redirect '/'
end

get '/*' do
  "ERROR404"
end

error do redirect '/' end