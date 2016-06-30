class PrefixRegistryTablesWithSpree < ActiveRecord::Migration
  def change
    rename_table :registries, :spree_registries
    rename_table :registryed_products, :spree_registryed_products
  end
end
