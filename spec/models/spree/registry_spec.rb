RSpec.describe Spree::Registry, type: :model do
  let(:user) { create(:user) }
  let(:registry) { create(:registry, user: user, name: 'My Registry') }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:registryed_products) }
  it { is_expected.to validate_presence_of(:name) }

  it 'has a valid factory' do
    expect(registry).to be_valid
  end

  context '.include?' do
    let(:variant) { create(:variant) }

    before do
      registryed_product = create(:registryed_product, variant: variant)
      registry.registryed_products << registryed_product
      registry.save
    end

    it 'is true if the registry includes the specified variant' do
      expect(registry.include?(variant.id)).to be true
    end
  end

  context '.to_param' do
    it 'returns the registries access_hash' do
      expect(registryt.to_param).to eq registry.access_hash
    end
  end

  context '.get_by_param' do
    it 'returns the registry of the access_hash' do
      hash = registry.access_hash
      result = described_class.get_by_param(hash)
      expect(result).to eq registry
    end

    it 'returns nil when not found' do
      result = described_class.get_by_param('nope')
      expect(result).to be_nil
    end
  end

  context '.can_be_read_by?' do
    context 'when the registry is private' do
      it 'is true when the user owns the registry' do
        registry.is_private = true
        expect(registry.can_be_read_by?(user)).to be true
      end

      it 'is false when the user does not own the registry' do
        registry.is_private = true
        other_user = create(:user)
        expect(registry.can_be_read_by?(other_user)).to be false
      end
    end

    context 'when the registry is public' do
      it 'is true for any user' do
        registry.is_private = false
        other_user = create(:user)
        expect(registry.can_be_read_by?(other_user)).to be true
      end
    end
  end

  context '.is_public?' do
    it 'is true when the registry is public' do
      registry.is_private = false
      expect(registry.is_public?).to be true
    end

    it 'is false when the registry is private' do
      registry.is_private = true
      expect(registry.is_public?).not_to be true
    end
  end

  context '#destroy' do
    let!(:registryed_product) { create(:registryed_product) }

    it 'deletes associated registryed products' do
      expect {
        registryed_product.registry.destroy
      }.to change(Spree::RegistryedProduct, :count).by(-1)
    end
  end
end