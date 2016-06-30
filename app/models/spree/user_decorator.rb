Spree.user_class.class_eval do
  has_many :registries, class_name: Spree::Registry

  def registry
    default_registry = registries.where(is_default: true).first
    default_registry ||= registries.first
    default_registry ||= registries.create(name: Spree.t(:default_registry_name), is_default: true)
    default_registry.update_attribute(:is_default, true) unless default_registry.is_default?
    default_registry
  end
end