require 'rspec/example_steps'

feature 'カート処理' do
  given!(:payment_method) { FactoryGirl.create(:payment_method) }
  given!(:shipment_method) { FactoryGirl.create(:shipment_method) }
  given(:order) { FactoryGirl.build(:order) }
  given(:address) { FactoryGirl.build(:address) }
  given(:stock) { product.stocks.first }

  shared_examples '商品が購入できること' do
    # refs:
    #   http://railsware.com/blog/2012/01/08/capybara-with-givenwhenthen-steps-in-acceptance-testing/
    #   http://d.hatena.ne.jp/bowbow99/20090523/1243043153
    Steps 'ゲスト購入' do
      Given '商品が存在するとき' do
        visit comable.products_path
        click_link subject.name
        expect(page).to have_content subject.price
      end

      When '商品をカートに投入して' do
        visit comable.product_path(subject)
        choose subject.stocks.first.code if subject.sku?
        click_button 'カートに入れる'
        expect(page).to have_content I18n.t('comable.carts.add_product')
      end

      When '注文画面に遷移して' do
        visit comable.cart_path
        click_link '注文'
        expect(page).to have_button '規約に同意して注文'
      end

      When '注文者情報入力画面に遷移して' do
        visit comable.new_order_path
        click_button '規約に同意して注文'
        expect(page).to have_content 'Billing address'
      end

      When '配送先情報入力画面に遷移して' do
        visit comable.next_order_path(state: :orderer)
        within('form') do
          fill_in :order_email, with: order.email
          fill_in :order_bill_address_attributes_family_name, with: address.family_name
          fill_in :order_bill_address_attributes_first_name, with: address.first_name
          fill_in :order_bill_address_attributes_state_name, with: address.state_name
          fill_in :order_bill_address_attributes_zip_code, with: address.zip_code
          fill_in :order_bill_address_attributes_city, with: address.city
          fill_in :order_bill_address_attributes_phone_number, with: address.phone_number
        end
        # TODO: ボタン名につかう翻訳パスを変更または作成
        click_button I18n.t('helpers.submit.update')
        expect(page).to have_content 'Shipping address'
      end

      When '発送方法選択画面に遷移して' do
        visit comable.next_order_path(state: :delivery)
        within('form') do
          fill_in :order_ship_address_attributes_family_name, with: address.family_name
          fill_in :order_ship_address_attributes_first_name, with: address.first_name
          fill_in :order_ship_address_attributes_state_name, with: address.state_name
          fill_in :order_ship_address_attributes_zip_code, with: address.zip_code
          fill_in :order_ship_address_attributes_city, with: address.city
          fill_in :order_ship_address_attributes_phone_number, with: address.phone_number
        end
        click_button I18n.t('helpers.submit.update')
        expect(page).to have_content '発送方法'
      end

      When '決済方法選択画面に遷移して' do
        visit comable.next_order_path(state: :shipment)
        click_button I18n.t('helpers.submit.update')
        expect(page).to have_content '決済方法'
      end

      When '注文情報確認画面に遷移して' do
        visit comable.next_order_path(state: :payment)
        click_button I18n.t('helpers.submit.update')
        expect(page).to have_content '注文情報確認'
      end

      Then '注文できること' do
        visit comable.next_order_path(state: :confirm)
        click_button I18n.t('helpers.submit.update')
        expect(page).to have_content '注文完了'
      end
    end
  end

  shared_examples '商品を数量指定でカート投入できること' do
    let(:quantity) { stock.quantity.to_s }

    Steps 'ゲスト購入' do
      Given '商品が存在するとき' do
        visit comable.products_path
        click_link subject.name
        expect(page).to have_content subject.price
      end

      When '商品をカートに投入して' do
        visit comable.product_path(subject)
        choose subject.stocks.first.code if subject.sku?
        select quantity, from: 'quantity'
        click_button 'カートに入れる'
        expect(page).to have_content I18n.t('comable.carts.add_product')
      end

      Then 'カートが更新されること' do
        visit comable.cart_path
        expect(page).to have_select('quantity', selected: quantity)
      end
    end
  end

  shared_examples '商品の数量変更ができること' do
    let(:quantity) { stock.quantity.to_s }

    Steps 'ゲスト購入' do
      Given '商品が存在するとき' do
        visit comable.products_path
        click_link subject.name
        expect(page).to have_content subject.price
      end

      When '商品をカートに投入して' do
        visit comable.product_path(subject)
        choose subject.stocks.first.code if subject.sku?
        click_button 'カートに入れる'
        expect(page).to have_content I18n.t('comable.carts.add_product')
      end

      When '数量を変更して' do
        visit comable.cart_path
        select quantity, from: 'quantity'
        click_button '変更'
        expect(page).to have_content I18n.t('comable.carts.update')
      end

      Then 'カートが更新されること' do
        visit comable.cart_path
        expect(page).to have_select('quantity', selected: quantity)
      end
    end
  end

  context '通常商品' do
    subject!(:product) { FactoryGirl.create(:product, :with_stock) }
    it_behaves_like '商品が購入できること'
    it_behaves_like '商品を数量指定でカート投入できること'
    it_behaves_like '商品の数量変更ができること'
  end

  context 'SKU商品' do
    subject!(:product) { FactoryGirl.create(:product, :sku) }
    it_behaves_like '商品が購入できること'
    it_behaves_like '商品を数量指定でカート投入できること'
    it_behaves_like '商品の数量変更ができること'
  end
end
