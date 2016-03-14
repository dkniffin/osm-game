$ ->
  $('#take-damage').on 'click', ->
    App.characters.take_damage(App.game.selected.data.id)

  $('#restore-health').on 'click', ->
    App.characters.restore_health(App.game.selected.data.id)

  $('#restore-food').on 'click', ->
    App.characters.restore_food(App.game.selected.data.id)

  $('#lose-food').on 'click', ->
    App.characters.lose_food(App.game.selected.data.id)
