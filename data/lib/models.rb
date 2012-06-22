class User < ActiveRecord::Base
end

class Content < ActiveRecord::Base
    validates :title, :presence => true
    validates :text, :presence => true
    #scope :is_enabled, where("is_enabled=true")
end