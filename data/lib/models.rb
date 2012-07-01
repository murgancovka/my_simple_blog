class User < ActiveRecord::Base
end

class Content < ActiveRecord::Base
    validates :title, :presence => { :message => "Title can't be blank" }
    validates :text, :presence => { :message => "Text can't be blank" }
    #scope :is_enabled, where("is_enabled=true")
    
    def self.search(search)
    search_condition = "%" + search + "%"
        if search
          find(:all, :conditions => ['title LIKE ? or text LIKE ? ', search_condition, search_condition], :limit => 20)
        else
          find :all
        end
    end
      
end