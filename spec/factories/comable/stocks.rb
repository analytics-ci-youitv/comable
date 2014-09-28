FactoryGirl.define do
  factory :stock, class: 'Comable::Stock' do
    product_id_num 1
    code '1234567-001'
    quantity nil

    ignore { sku_flag false }

    trait :many do
      sequence(:product_id_num) { |n| n.next }
      sequence(:code) { |n| format('%07d', n.next) }
    end

    trait :sku do
      ignore { sku_flag true }
      sku_h_choice_name 'レッド'
      sku_v_choice_name 'S'
    end

    trait :with_product do
      after(:build) do |stock, evaluator|
        attributes = { code: stock.code }
        attributes.update(sku_h_item_name: 'カラー', sku_v_item_name: 'サイズ') if evaluator.sku_flag
        stock.product = build_stubbed(:product, attributes)
      end

      after(:create) do |stock, evaluator|
        attributes = { code: stock.code, stocks: [stock] }
        attributes.update(sku_h_item_name: 'カラー', sku_v_item_name: 'サイズ') if evaluator.sku_flag
        create(:product, attributes)
      end
    end

    trait :soldout do
      quantity 0
    end

    trait :unsold do
      quantity 10
    end

    trait :inavtivated do
      product_id_num nil
    end
  end
end
