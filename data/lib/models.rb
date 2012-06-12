class User < ActiveRecord::Base
end

class Content < ActiveRecord::Base
    scope :is_enabled, where("is_enabled=true")
end