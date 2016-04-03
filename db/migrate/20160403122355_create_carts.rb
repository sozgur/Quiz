class CreateCarts < ActiveRecord::Migration
  def change
  	create_table :carts do |t|
  		t.integer :identifier
  		t.integer :user_id

  		t.timestamps
  	end
  end
end
