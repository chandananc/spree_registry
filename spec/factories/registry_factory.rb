FactoryGirl.define do
  factory :registry, class: Spree::Registry do
    user
    sequence(:name) { |n| "Registry_#{n}" }
    is_private true
    is_default false
  end
end