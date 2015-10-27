feature 'Variants', js: true do
  given(:option_type_color) { build(:option_type, name: 'Color') }
  given(:option_type_size) { build(:option_type, name: 'Size') }
  given(:option_value_red) { build(:option_value, name: 'Red') }
  given(:option_value_s) { build(:option_value, name: 'S') }
  given(:option_value_m) { build(:option_value, name: 'M') }

  authorization! :admin_user

  scenario 'Create a new variant' do
    visit comable.new_admin_product_path

    fill_in :product_name, with: build(:product).name

    # Input a type and value for a new variant
    click_link Comable.t('admin.add_variants')
    fill_in_option :first, name: option_type_color.name, values: option_value_red.name

    click_on Comable.t('admin.actions.save')

    expect(page).to have_content Comable.t('successful')

    expect(find_option_type(:first)).to eq(option_type_color.name)
    expect(find_option_values(:first)).to include(option_value_red.name)
  end

  scenario 'Create a new variants' do
    visit comable.new_admin_product_path

    fill_in :product_name, with: build(:product).name

    # Input types and values for new variants
    click_link Comable.t('admin.add_variants')
    click_link Comable.t('admin.add_variants')
    fill_in_option :first, name: option_type_color.name, values: option_value_red.name
    fill_in_option :last, name: option_type_size.name, values: [option_value_s, option_value_m].map(&:name)

    click_on Comable.t('admin.actions.save')

    expect(page).to have_content Comable.t('successful')
    expect(find_option_type(:first)).to eq(option_type_color.name)
    expect(find_option_values(:first)).to include(option_value_red.name)
    expect(find_option_type(:last)).to eq(option_type_size.name)
    expect(find_option_values(:last)).to include(option_value_s.name)
    expect(find_option_values(:last)).to include(option_value_m.name)
  end

  scenario 'Create a new product without options' do
    visit comable.new_admin_product_path

    fill_in :product_name, with: build(:product).name

    click_on Comable.t('admin.actions.save')

    expect(page).to have_content Comable.t('successful')

    id = current_url.split('/').last
    product = Comable::Product.find(id)
    expect(product.variants.count).to eq(1)
  end

  scenario 'Update the quantity of the product without options' do
    product = create(:product, :with_stock)
    stock = product.stocks.first
    new_quantity = stock.quantity + 100

    visit comable.admin_product_path(product)

    fill_in :product_variants_attributes_0_quantity, with: new_quantity

    click_on Comable.t('admin.actions.save')

    expect(page).to have_content Comable.t('successful')
    expect(stock.reload.quantity).to eq(new_quantity)
  end

  private

  def fill_in_option(offset, name:, values:)
    option = all('.comable-option').send(offset)
    option_type = option.all('input').first
    option_type.set(name)

    values = [values] unless values.is_a? Array
    return if values.empty?

    script = "var option = $('.comable-option').#{offset}();"
    script << values.map { |value| "option.find('.js-tagit-option-values').tagit('createTag', '#{value}');" }.join
    page.execute_script script
  end

  def find_option_type(offset)
    index = all('.comable-option-values').send(offset)['data-index']
    find("input#product_option_types_attributes_#{index}_name").value
  end

  def find_option_values(offset)
    page.evaluate_script "$('.comable-option').#{offset}().find('.js-tagit-option-values').tagit('assignedTags');"
  end
end
