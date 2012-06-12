helpers do
    def require_login
      redirect_with_error_message('/', 'Please login first') unless session[:id]
    end 
  
    def authenticate(username, password)
        user=User.find(:first, :conditions=>["username=?", username])
        if user
          if user.password==Digest::SHA1.hexdigest(password)
            session[:id] = user.id.to_s
            session[:user] = user.username.to_s
            return true
          else
            return false
          end
        else
           return false
        end
        return false
    end

    def check_profile_passwords(password,rpassword)
      @user=User.find(:first, :conditions=>["id=?", session[:id]])
      if (((password==rpassword) and (!password.blank? or !rpassword.blank?) and ((password.length >= 3) and (rpassword.length >= 3))))
	#if ((password.length >= 3) and (rpassword.length >= 3))
	  @user.password=Digest::SHA1.hexdigest(password)
	  @user.save
	  flash[:notice] = "Your data successuflly changed!"
	#else
	#  flash[:error] = "Error! Password length should be at least 3 symbols!"
	#end
	#  flash[:notice] = "Your data successuflly changed!"
      else
	flash[:error] = "Error! Passwords don\'t match or password length less than 3 symbols"
      end
    end

    def redirect_with_notice_message(to_location, message)
      flash[:notice] = message
      redirect to_location
    end  
    
    def redirect_with_error_message(to_location, message)
      flash[:error] = message
      redirect to_location
    end   

end
