RSpec.describe Spree::RegistriesController, type: :controller do
  let(:registry)   { create(:registry) }
  let(:user)       { registry.user }
  let(:attributes) { attributes_for(:registry) }

  before { allow(controller).to receive(:spree_current_user).and_return(user) }

  context '#new' do
    it 'assigns a new registry as @registry' do
      spree_get :new
      expect(assigns(:registry)).to be_a_new Spree::Registry
    end
  end

  context '#index' do
    it 'assigns all registries as @registries' do
      spree_get :index
      expect(assigns(:registries)).to eq user.registries
    end
  end

  context '#edit' do
    it 'assigns the requested registry as @registry' do
      spree_get :edit, id: registry
      expect(assigns(:registry)).to eq registry
    end
  end

  context '#update' do
    it 'assigns @registry' do
      spree_put :update, id: registry, registry: attributes
      expect(assigns(:registry)).to eq registry
    end

    context 'when the registry updates successfully' do
      it 'redirects to the updated registry' do
        spree_put :update, id: registry, registry: attributes
        expect(response).to redirect_to registry
      end

      it 'sets the attributes of @registry according to attributes' do
        spree_put :update, id: registry, registry: attributes
        attributes.each do |attr_name, value|
          expect(assigns(:registry).send(attr_name)).to eq value
        end
      end
    end

    context 'when the registry fails to update' do
      it 'raise error' do
        expect {
          spree_put :update, id: registry, registry: {}
        }.to raise_error
      end
    end
  end

  context '#show' do
    it 'assigns the requested registry as @registry' do
      spree_get :show, id: registry
      expect(assigns(:registry)).to eq registry
    end

    # Regression test for issue #68
    it 'raises record not found on invalid params' do
      expect {
        spree_get :show, id: 'nope'
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context '#default' do
    it 'retrieves the default registry of the current user' do
      allow_any_instance_of(Spree::User).to receive(:registry)
      spree_get :default
    end

    it 'assigns the default registry as @registry' do
      spree_get :default
      expect(assigns(:registry)).to eq user.registry
    end

    it 'renders the registries/show template' do
      spree_get :default
      expect(response).to render_template 'spree/registries/show'
    end
  end

  context '#create' do
    it 'assigns @registry' do
      spree_post :create, registry: attributes
      expect(assigns(:registry)).to be_a Spree::Registry
    end

    it 'sets the current user as the user of @registry' do
      spree_post :create, registry: attributes
      expect(assigns(:registry).user).to eq user
    end

    context 'when the registry saves successfully' do
      it 'saves the new registry' do
        expect {
          spree_post :create, registry: attributes
        }.to change(Spree::Registry, :count).by(1)
      end

      it 'redirects to the newly created registry' do
        spree_post :create, registry: attributes
        expect(response).to redirect_to user.registries.last
      end

      it 'sets the attributes of @registry according to attributes' do
        spree_post :create, registry: attributes
        attributes.each do |attr_name, value|
          expect(assigns(:registry).send(attr_name)).to eq value
        end
      end
    end

    context 'when the registry fails to save' do
      it 'raise error' do
        expect {
          spree_post :create, registry: {}
        }.to raise_error
      end
    end
  end

  context '#destroy' do
    it 'destroys the requested registry' do
      expect {
        spree_delete :destroy, id: registry
      }.to change(Spree::Registry, :count).by(-1)
    end

    it 'redirects to the users account page' do
      spree_delete :destroy, id: registry
      expect(response).to redirect_to spree.account_path
    end
  end
end