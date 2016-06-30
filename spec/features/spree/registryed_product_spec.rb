RSpec.feature 'Registryed Product', :js do
  given(:user) { create(:user) }

  context 'add' do
    given(:product) { create(:product) }

    background do
      sign_in_as! user
    end

    scenario 'when user has a default registry' do
      registry = create(:registry, is_default: true, user: user)

      add_to_registry product

      expect(page).to have_content registry.name
      expect(page).to have_content product.name
    end

    scenario 'when user has no default but with non-default registry' do
      registry = create(:registry, is_default: false, user: user)

      add_to_registry product

      expect(registry.reload.is_default).to be true
      expect(page).to have_content registry.name
      expect(page).to have_content product.name
    end

    scenario 'when user has no registry at all' do
      expect(user.registries).to be_empty

      add_to_registry product

      expect(user.registries.reload.count).to eq(1)
      expect(page).to have_content user.registries.first.name
      expect(page).to have_content product.name
    end

    scenario 'when user chooses different quantity of item' do
      registry = create(:registry, user: user)

      visit spree.product_path(product)
      fill_in "quantity", with: "15"
      click_button 'Add to registry'

      expect(page).to have_content product.name
      expect(page).to have_selector("input[value='15']")
    end
  end

  context 'delete' do
    given(:registry) { create(:registry, user: user) }

    background do
      sign_in_as! user
    end

    scenario 'from a registry with one registryed product' do
      registryed_product = create(:registryed_product, registry: registry)

      visit spree.registry_path(registry)

      wp_path = spree.registryed_product_path(registryed_product)
      delete_links = find(:xpath, '//table[@id="registry"]/tbody').all(:xpath, './/tr/td/p/a')
      delete_link = delete_links.select { |link| link[:href] == wp_path }.first
      delete_link.click

      expect(page).not_to have_content registryed_product.variant.product.name
    end

    scenario 'randomly from a registry with multiple registryed products while maintaining ordering by date added' do
      registryed_products = [
        create(:registryed_product, registry: registry),
        create(:registryed_product, registry: registry),
        create(:registryed_product, registry: registry)
      ]
      registryed_product = registryed_products.delete_at(Random.rand(registryed_products.length))

      visit spree.registry_path(registry)

      wp_path = spree.registryed_product_path(registryed_product)
      delete_links = find(:xpath, '//table[@id="registry"]/tbody').all(:xpath, './/tr/td/p/a')
      delete_link = delete_links.select { |link| link[:href] == wp_path }.first
      delete_link.click
      pattern = Regexp.new(registryed_products.map { |wp| wp.variant.product.name }.join('.*'))

      expect(page).not_to have_content registryed_product.variant.product.name
      expect(page).to have_content pattern
    end
  end

  private

  def add_to_registry(product)
    visit spree.product_path(product)
    click_button 'Add to Registry'
  end
end