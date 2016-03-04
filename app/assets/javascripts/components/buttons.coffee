$ ->
  $('#view-more-link').on 'click', ->
    App.characters.take_damage(App.game.selected.data.id)
