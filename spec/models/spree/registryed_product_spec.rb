RSpec.describe Spree::RegistryedProduct, type: :model do

  it { is_expected.to belong_to(:variant) }
  it { is_expected.to belong_to(:registry) }

  it 'has a valid factory' do
    expect(build(:registryed_product)).to be_valid
  end

  describe '#quantity' do
    subject { build(:registryed_product) }

    it { is_expected.to respond_to(:quantity) }
    it { expect(subject.quantity).to eq(1) }
  end
end