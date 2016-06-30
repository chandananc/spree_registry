class Spree::RegistryedProductsController < Spree::StoreController
  respond_to :html

  def create
    @registryed_product = Spree::RegistryedProduct.new(registryed_product_attributes)
    @registry = spree_current_user.registry

    if @registry.include? params[:registryed_product][:variant_id]
      @registryed_product = @registry.registryed_products.detect { |wp| wp.variant_id == params[:registryed_product][:variant_id].to_i }
    else
      @registryed_product.registry = spree_current_user.registry
      @registryed_product.save
    end

    respond_with(@registryed_product) do |format|
      format.html { redirect_to registry_url(@registry) }
    end
  end

  def update
    @registryed_product = Spree::RegistryedProduct.find(params[:id])
    @registryed_product.update_attributes(registryed_product_attributes)

    respond_with(@registryed_product) do |format|
      format.html { redirect_to registry_url(@registryed_product.registry) }
    end
  end

  def destroy
    @registryed_product = Spree::RegistryedProduct.find(params[:id])
    @registryed_product.destroy

    respond_with(@registryed_product) do |format|
      format.html { redirect_to registry_url(@registryed_product.registry) }
    end
  end

  private

  def registryed_product_attributes
    params.require(:registryed_product).permit(:variant_id, :registry_id, :remark, :quantity)
  end
end