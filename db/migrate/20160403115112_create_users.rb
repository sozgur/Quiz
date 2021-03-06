class CreateUsers < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  	  t.string :username, :null => false, :unique => true
      t.string :name  
      t.string :email,   :null => false, :unique => true
      t.string :password,  :null => false
      
      t.timestamps
  	end
  end
end
