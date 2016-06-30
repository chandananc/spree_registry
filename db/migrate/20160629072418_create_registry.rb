class CreateRegistry < ActiveRecord::Migration
  def self.up
    create_table :registries do |t|
       t.references :user
      t.string :name
      t.string :access_hash
      t.boolean :is_private, default: true, null: false
      t.boolean :is_default, default: false, null: false

      t.timestamps null: false
      
    end
  end
  
   def self.down
    drop_table :registries
   end
  
end
