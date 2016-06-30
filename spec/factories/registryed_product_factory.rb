FactoryGirl.define do
  factory :registryed_product, class: Spree::RegistryedProduct do
    variant
    registry
    remark 'Some remark..'
  end
end