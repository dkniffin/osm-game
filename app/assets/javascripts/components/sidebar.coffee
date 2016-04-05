$ ->
  $('.sidebar .sidebar__section').hide()

  $('input[name=current_action]').change (e) ->
    App.game.current_action = e.target.value

  $('.inventory').click '.item-action', (e) ->
    item_id = $(e.target).data('item-id')
    App.characters.use_item(App.game.selected.data.id, item_id)
