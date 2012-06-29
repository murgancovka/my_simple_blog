class User < ActiveRecord::Base
end

class Content < ActiveRecord::Base
    validates :title, :presence => { :message => "Title can't be blank" }
    validates :text, :presence => { :message => "Text can't be blank" }
    #scope :is_enabled, where("is_enabled=true")
end