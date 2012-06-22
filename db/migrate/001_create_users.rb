class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
        t.string  :username
        t.string  :password
        t.boolean :is_enabled
        t.string  :email
        t.text    :about

        t.timestamps
    end

    create_table :contents do |t|
        t.references  :user
        t.string      :title
        t.string      :text
        t.boolean     :is_enabled

        t.timestamps
    end
    
  end
end
