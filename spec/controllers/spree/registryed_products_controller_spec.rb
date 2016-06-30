RSpec.describe Spree::RegistryedProductsController, type: :controller do
  let(:user)           { create(:user) }
  let!(:registryed_product) { create(:registryed_product) }
  let(:attributes)     { attributes_for(:registryed_product) }

  before { allow(controller).to receive(:spree_current_user).and_return(user) }

  context '#create' do
    context 'with valid params' do
      it 'creates a new Spree::RegistryedProduct' do
        expect {
          spree_post :create, Registryed_product: attributes
        }.to change(Spree::RegistryedProduct, :count).by(1)
      end

      it 'assigns a newly created registryed_product as @registryed_product' do
        spree_post :create, registryed_product: attributes
        expect(assigns(:registryed_product)).to be_a Spree::RegistryedProduct
        expect(assigns(:registryed_product)).to be_persisted
      end

      it 'redirects to the created registryed_product' do
        spree_post :create, registryed_product: attributes
        expect(response).to redirect_to spree.registry_path(Spree::RegistryedProduct.last.registry)
      end

      it 'does not save if registryed product already exist in registry' do
        variant  = create(:variant)
        registry = create(:registry, user: user)
        registryed_product = create(:registryed_product, registry: registry, variant: variant)
        expect {
          spree_post :create, id: registryed_product.id, registryed_product: { registry_id: registry.id, variant_id: variant.id }
        }.to change(Spree::RegistryedProduct, :count).by(0)
      end
    end

    context 'with invalid params' do
      it 'raises error' do
        expect { spree_post :create }.to raise_error
      end
    end
  end

  context '#update' do
    context 'with valid params' do
      it 'assigns the requested registryed_product as @registryed_product' do
        spree_put :update, id: registryed_product, registryed_product: attributes
        expect(assigns(:registryed_product)).to eq registryed_product
      end

      it 'redirects to the registryed_product' do
        spree_put :update, id: registryed_product, registryed_product: attributes
        expect(response).to redirect_to spree.registry_path(registryed_product.registry)
      end
    end

    context 'with invalid params' do
      it 'raises error' do
        expect { spree_put :update }.to raise_error
      end
    end
  end

  context '#destroy' do
    it 'destroys the requested registryed_product' do
      expect {
        spree_delete :destroy, id: registryed_product
      }.to change(Spree::RegistryedProduct, :count).by(-1)
    end

    it 'redirects to the registryed_products list' do
      spree_delete :destroy, id: registryed_product
      expect(response).to redirect_to spree.registry_path(registryed_product.registry)
    end

    it 'requires the :id parameter' do
      expect { spree_delete :destroy }.to raise_error
    end
  end
end