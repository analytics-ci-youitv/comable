#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require jstree
#= require bootstrap-sprockets
#= require raphael
#= require morris
#= require pace/pace
#= require_tree .

$( ->
  # ---
  # functions
  # ---

  initialize_vertical_navigation = ->
    $vnavigation = $('.vnavigation').find('ul')

    $('.vnavigation ul li ul').each( ->
      $target_navitem = $(this).parent()
      $target_navitem.addClass('parent')
    )

    $('.vnavigation ul li ul li.active').each( ->
      $target_navitem_children = $(this).parent()
      $target_navitem_children.css(display: 'block')
      $target_navitem_children.parent().addClass('open')
    )

    $vnavigation.delegate('.parent > a', 'click', (event) ->
      $target_navitem = $(this).parent()
      $target_navitem_children = $target_navitem.find('ul')

      $vnavigation.find('.parent.open > ul').not($target_navitem_children).slideUp(300, 'swing', ->
        $target_navitem.removeClass('open')
      )

      $target_navitem_children.slideToggle(300, 'swing', ->
        $target_navitem.toggleClass('open')
        #$('#cl-wrapper .nscroller').nanoScroller(preventPageScrolling: true)
      )

      event.preventDefault()
    )

  initialize_comable_affix = ->
    $affix = $('#comable-affix')
    $affix_top = $affix.offset().top
    $affix.affix({
      offset: {
        top: ->
          if $affix.hasClass('affix-top')
            $affix_top - $('header').height() - 20
          else
            $affix_top
      }
    })

  resize_comable_affix = ->
    $affix = $('#comable-affix')
    $affix.css('width', $affix.parent().width())

  notify_flash_message = ->
    $notifier = $('#comable-notifier')
    return if $notifier.length <= 0
    $notifier.on('click', -> $(this).clearQueue().animate({ height: 0 }))
    height = $notifier.css('height')
    $notifier
      .removeClass('hidden')
      .css({ height: 0 })
      .delay(400)
      .animate({ height: height })
      .delay(5 * 1000)
      .animate({ height: 0 })

  # ---
  # main
  # ---

  initialize_vertical_navigation()

  if $('#comable-affix').length != 0
    initialize_comable_affix()
    resize_comable_affix()
    $(window).on('resize', resize_comable_affix)

  notify_flash_message()
)
