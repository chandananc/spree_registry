Deface::Override.new(
  virtual_path: 'spree/products/show',
  name: 'add_registry_to_cart_form',
  insert_bottom: "[data-hook='cart_form']",
  partial: 'spree/products/registry_form'
)