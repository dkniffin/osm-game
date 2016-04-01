$ ->
  $('.sidebar .sidebar__section').hide()

  $('input[name=current_action]').change (e) ->
    App.game.current_action = e.target.value
