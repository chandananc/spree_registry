Spree::Variant.class_eval do
  has_many :registryed_products, dependent: :destroy
end