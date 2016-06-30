FactoryGirl.define do
  factory :user_with_registry, parent: :user do
    after :create do |user|
      user << create(:registry)
      user.save
      user.reload
    end
  end
end