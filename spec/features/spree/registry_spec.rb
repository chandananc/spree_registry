RSpec.feature 'Registry', :js do
  context 'with no registry' do
    given!(:user) { create(:user) }

    background do
      sign_in_as! user
    end

    context 'create' do
      scenario 'when user has no existing registry' do
        product = create(:product)
        visit spree.product_path(product)
        click_button 'Add to registry'

        expect(page).to have_content user.registries.first.name
      end

      scenario 'when user has an existing registry' do
        registry = create(:registry, user: user)

        visit spree.account_path
        click_link registry.name
        click_link 'Create new registry'

        fill_in 'Name', with: 'A New Registry Name'
        click_button 'Create'

        expect(page).to have_content 'A New Registry Name'
      end

      scenario 'when user makes use of the new registry path' do
        visit spree.new_registry_path
        fill_in 'Name', with: 'A New Registry Name'
        click_button 'Create'

        expect(page).to have_content 'A New Registry Name'
      end
    end
  end

  context 'with existing registry' do
    given(:registry) { create(:registry) }
    given(:user)     { registry.user }

    background do
      sign_in_as! user
    end

    context 'edit' do
      scenario 'edit a registries name' do
        visit_edit_registry

        fill_in 'Name', with: 'A New Registry Name'
        click_button 'Update'

        expect(page).to have_content 'A New Registry Name'
      end

      context 'edit a registries is_private' do
        scenario 'set registry from private to public' do
          registry.is_private = true
          registry.save

          visit_edit_registry

          uncheck 'is private'
          click_button 'Update'

          expect(page).to have_checked_field 'registry_is_private_false'
        end

        scenario 'set registry from public to private' do
          registry.is_private = false
          registry.save

          visit_edit_registry

          check 'is private'
          click_button 'Update'

          expect(page).to have_checked_field 'registry_is_private_true'
        end
      end

      context 'edit a registries is_default' do
        scenario 'set registry from default to non-default' do
          registry.is_default = true
          registry.save

          visit_edit_registry

          uncheck 'is default'
          click_button 'Update'
          click_link 'Edit registry'

          expect(page).to have_unchecked_field 'is default'
        end

        scenario 'set registry from non-default to default' do
          registry.is_default = false
          registry.save

          visit_edit_registry

          check 'is default'
          click_button 'Update'
          click_link 'Edit registry'

          expect(page).to have_checked_field 'is default'
        end
      end
    end

    context 'delete' do
      scenario 'delete a users registry' do
        visit_edit_registry
        click_link 'Delete registry'
        expect(page).not_to have_content registry.name
      end
    end
  end

  private

  def visit_edit_registry
    visit spree.account_path
    click_link registry.name
    click_link 'Edit registry'
  end
end