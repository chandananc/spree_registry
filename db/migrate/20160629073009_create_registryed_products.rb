class CreateRegistryedProducts < ActiveRecord::Migration
  def self.up
    create_table :registryed_products do |t|
      t.references :variant
      t.references :registry
      t.text :remark

      t.timestamps null: false
    end
  end
  
   def self.down
    drop_table :registryed_products
   end
end
