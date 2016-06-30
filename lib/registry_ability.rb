class RegistryAbility
  include CanCan::Ability

  def initialize(user)
    user ||= Spree::User.new # correct?

    # Anyone can create a registry
    can :create, Spree::Registry do
      !user.new_record?
    end

    # Anyone can index registry
    can :index, Spree::Registry do
      !user.new_record?
    end

    # Anyone can add registry product to registry
    can :create, Spree::RegistryedProduct do
      !user.new_record?
    end

    # You can your own registries, and everyone cas see public ones
    can :read, Spree::Registry do |registry|
      registry.user == user || registry.is_public?
    end

    # You can only change your own registry
    can [:read, :move, :update, :edit, :destroy], Spree::Registry do |registry|
      registry.user == user
    end

    # You can only view own registry product unless registry public
    can :read, Spree::RegistryedProduct do |registryed_product|
      registryed_product.registry.user == user || registryed_product.registry.is_public?
    end

    # You can only browse or change own registry product
    can [:index, :update, :destroy], Spree::RegistryedProduct do |registryed_product|
      registryed_product.registry.user == user
    end
  end
end