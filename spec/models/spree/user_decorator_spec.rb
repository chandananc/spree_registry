RSpec.describe Spree::User, type: :model do

  it { is_expected.to have_many(:registries).class_name('Spree::Registry') }

  it 'has a valid factory' do
    expect(build(:user_with_registry)).to be_valid
  end
end