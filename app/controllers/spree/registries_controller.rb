class Spree::RegistriesController < Spree::StoreController
  helper 'spree/products'

  before_action :find_registry, only: [:destroy, :show, :update, :edit]

  respond_to :html
  respond_to :js, only: :update

  def new
    @registry = Spree::Registry.new
    respond_with(@registry)
  end

  def index
    @registries = spree_current_user.registries
    respond_with(@registry)
  end

  def edit
    respond_with(@list)
  end

  def update
    @registry.update_attributes registry_attributes
    respond_with(@registry)
  end

  def show
    respond_with(@registry)
  end

  def default
    @registry = spree_current_user.registry
    respond_with(@registry) do |format|
      format.html { render :show }
    end
  end

  def create
    @registry = Spree::Registry.new registry_attributes
    @registry.user = spree_current_user
    @registry.save
    respond_with(@registry)
  end

  def destroy
    @registry.destroy
    respond_with(@registry) do |format|
      format.html { redirect_to account_path }
    end
  end

  private

  def registry_attributes
    params.require(:registry).permit(:name, :is_default, :is_private)
  end

  # Isolate this method so it can be overwritten
  def find_registry
    @registry = Spree::Registry.find_by_access_hash!(params[:id])
  end
end