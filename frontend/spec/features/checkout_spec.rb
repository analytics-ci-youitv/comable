feature 'Checkout' do
  given!(:persisted_user) { FactoryGirl.create(:user, :with_addresses, password: 'raw-passowrd') }
  given!(:order) { FactoryGirl.create(:order, :for_confirm, order_details: [order_detail]) }

  given(:order_detail) { FactoryGirl.build(:order_detail) }
  given(:current_comable_user) { FactoryGirl.build(:user) }

  background do
    allow(Comable::User).to receive(:new).and_return(current_comable_user)
    allow(current_comable_user).to receive(:incomplete_order).and_return(order)
    allow_any_instance_of(Comable::User).to receive(:current_guest_token).and_return(order.guest_token)
  end

  context "when order state was 'cart'" do
    background { order.update_attributes(state: 'cart', email: nil) }

    scenario 'Sign in while checkout flow' do
      visit comable.cart_path

      click_button Comable.t('checkout')

      expect(current_url).to eq(comable.signin_order_url)

      within('form#new_user') do
        fill_in :user_email, with: persisted_user.email
        fill_in :user_password, with: persisted_user.password
      end
      click_button 'Log in'

      expect(current_url).to eq(comable.next_order_url(state: :confirm))
    end
  end

  context "when order state was 'confirm'" do
    background { order.update_attributes(state: 'confirm') }

    scenario 'Update the billing address' do
      visit comable.next_order_path(state: :orderer)

      within('form') do
        fill_in :order_email, with: "updated.#{order.email}"
      end
      click_button Comable.t('next_step')

      expect(current_url).to eq(comable.next_order_url(state: :confirm))
      expect(order.state).to eq('confirm')
    end
  end
end
