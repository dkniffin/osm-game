$ ->
  $('#take-damage').on 'click', ->
    App.characters.take_damage(App.game.selected.data.id)

  $('#restore-health').on 'click', ->
    App.characters.restore_health(App.game.selected.data.id)
