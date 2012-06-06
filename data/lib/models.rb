class User < ActiveRecord::Base
    before_update :check_passwords
    
    def check_passwords
        user=User.find(:first,:conditions=>["id=?", self.id])
        if !user
            #user.update("password='xaaxax'")
            puts ":D:D:D:"
        end
    end
end

class Country < ActiveRecord::Base
    scope :is_enabled, where("is_enabled=true")
end

class City < ActiveRecord::Base
    scope :related_with_country, where("is_enabled=true")
end

class NewsItem < ActiveRecord::Base
    scope :is_enabled, where("is_enabled=true")
end

class Content < ActiveRecord::Base
    scope :is_enabled, where("is_enabled=true")
end