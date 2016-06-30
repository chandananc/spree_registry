class AddQuantityToRegistryedProducts < ActiveRecord::Migration
  def change
    add_column :spree_registryed_products, :quantity, :integer, null: false, default: 1
  end
end
