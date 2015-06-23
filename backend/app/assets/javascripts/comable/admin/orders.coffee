class @DynamicOrder
  constructor: (@options = {}) ->
    @options['order_item_selector'] = '.comable-order-items' unless @options['order_item_selector']
    @listen_events()

  listen_events: ->
    self = this
    selector = @options['order_item_selector']
    $(->
      $(selector).find('input').on('change', ->
        attribute_name = $(this).attr('data-name')
        return if (attribute_name != 'price' && attribute_name != 'quantity')
        self.refresh_order_item_prices_for(this)
      )
    )

  refresh_order_item_prices_for: (element) ->
    $group = $(element).closest(@options['order_item_selector'])

    $price = $group.find('[data-name="price"]')
    $quantity = $group.find('[data-name="quantity"]')
    $subtotal_price = $group.find('[data-name="subtotal_price"]')

    price = Number($price.val())
    quantity = Number($quantity.val())
    $subtotal_price.val(price * quantity)

    @refresh_order_prices()

  refresh_order_prices: ->
    item_total_price = 0
    $('[data-name="subtotal_price"]').each( ->
      item_total_price += Number($(this).val())
    )

    $item_total_price = $('[data-name="item_total_price"]')
    $payment_fee = $('[data-name="payment_fee"]')
    $shipment_fee = $('[data-name="shipment_fee"]')
    $total_price = $('[data-name="total_price"]')

    payment_fee = Number($payment_fee.val())
    shipment_fee = Number($shipment_fee.val())

    $item_total_price.val(item_total_price)
    $total_price.val(item_total_price + payment_fee + shipment_fee)
