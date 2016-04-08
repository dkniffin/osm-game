$ ->
  $('.sidebar .sidebar__section').hide()

  $('input[name=current_action]').change (e) ->
    App.game.current_action = e.target.value

  $('.inventory').on 'click', '.use-item', (e) ->
    item_id = $(e.target).data('item-id')
    App.characters.use_item(App.game.selected.data.id, item_id)

  $('.inventory').on 'click', '.equip-item', (e) ->
    item_id = $(e.target).data('item-id')
    App.characters.equip_item(App.game.selected.data.id, item_id)
