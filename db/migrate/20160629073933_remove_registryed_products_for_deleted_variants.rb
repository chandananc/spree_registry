class RemoveRegistryedProductsForDeletedVariants < ActiveRecord::Migration
  def up
    Spree::RegistryedProduct.includes(:variant).find_each do |registryed_product|
      registryed_product.destroy unless registryed_product.variant
    end
  end

  def down
  end
end
