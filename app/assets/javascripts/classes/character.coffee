class window.Character

  DESELECTED_OPACITY = 0.7
  SELECTED_OPACITY = 1.0
  @_characters: {}

  @sidebarSection = $('.sidebar .sidebar__character')

  @get: (id) ->
    @_characters[id]

  @upsert: (id, data) ->
    data = JSON.parse(data)
    if @_characters[id] == undefined
      console.debug('making new character')
      @_characters[id] = new Character(data)
    else
      @_characters[id].update(data)
    @_characters[id]

  constructor: (@data) ->
    @marker = L.marker([@data['lat'], @data['lon']],
      {icon: @_characterIcon(@data['icon_url'], @data['health']), opacity: DESELECTED_OPACITY})
    if App.map_mode == '3d'
      @model = App.osmb.addOBJ(App.models.character,
      { latitude: @data['lat'], longitude: @data['lon'] },
      { id: "character_#{@data['id']}", color: 'tan' })
    else
      @marker.on('click', @select.bind(this))
      @marker.addTo(App.leaflet_map)

    if @data['user_id'] == parseInt(Cookies.get('user_id'))
      App.leaflet_map.panTo(@marker.getLatLng())

    # @marker.addTo(App.minimap)

  update: (data) ->
    @data = data

    if App.map_mode == '3d'
      @model.position = {latitude: data['lat'], longitude: data['lon']}
    else
      @marker.setIcon(@_characterIcon(data.icon_url, data.health))

    @marker.setLatLng([data['lat'], data['lon']])

    $('.header .health .value').html(data.health)
    $('.header .food .value').html(data.food)
    $('.header .water .value').html(data.water)
    if App.game.selected == this
      @_updateSidebar()

  select: (e) ->
    App.game.selected = this
    if App.map_mode == '2d'
      @marker.setOpacity(SELECTED_OPACITY)
    App.game.current_action = 'move'
    @_updateSidebar()

  unselect: (e) ->
    App.game.selected = null
    if App.map_mode == '3d'
      App.osmb.highlight(@data['id'])
    else
      @marker.setOpacity(DESELECTED_OPACITY)
    App.game.current_action = null
    @_hideSidebar()

  _updateSidebar: ->
    sidebar = $('.sidebar .sidebar__character')
    sidebar.find('.character-image').attr('src', @data.icon_url)
    sidebar.find('.name').html(@data.name)
    sidebar.find('.health').html(@data.health)
    sidebar.find('.equipped').html(@_equippedHTML(@data.equipped_items))
    sidebar.find('.inventory').html(@_inventoryHTML(@data.inventory))
    sidebar.find("input[name=current_action]").val([App.game.current_action])
    sidebar.show()

  _hideSidebar: ->
    sidebar = $('.sidebar .sidebar__character')
    sidebar.hide()

  _characterIcon: (iconUrl, health) ->
    L.divIcon({
      className: 'character-icon'
      iconSize:     [48, 48]
      iconAnchor:   [12, 12]
      html: "#{@_characterIconHTML(iconUrl, health)}"
    })

  _inventoryHTML: (items) ->
    $.map items, (item, i) ->
      use_link = "<a class='item-action use-item' data-item-id='#{item['id']}'>Use</a>"
      if item.equippable
        equip_link = "<a class='item-action equip-item' data-item-id='#{item['id']}'>Equip</a>"
      else
        equip_link = ""
      "<li>#{item['name']} #{use_link} #{equip_link}</li>"

  _equippedHTML: (items) ->
    $.map items, (item, i) ->
      unequip_link = "<a class='item-action unequip-item' data-item-id='#{item['id']}'>Unequip</a>"
      "<li>#{item['name']} #{unequip_link}</li>"

  _characterIconHTML: (iconUrl, health) ->
    "<div class=progress-bar-outside>" +
      "<div class=progress-bar-inside style='width: #{health}%;'></div>" +
    "</div>" +
    "<img src=#{iconUrl}>"
