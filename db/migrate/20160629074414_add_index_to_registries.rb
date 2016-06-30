class AddIndexToRegistries < ActiveRecord::Migration
  def change
    add_index :spree_registries, [:user_id]
    add_index :spree_registries, [:user_id, :is_default]
  end
end
