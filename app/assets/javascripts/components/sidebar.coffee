do($ = window.jQuery, window) ->

  class Sidebar

    defaults:
      classNames:
        VISIBILITY_CLASSES: 'section--open section--closed'

    constructor: (el, options) ->
      @options = $.extend({}, @defaults, options)
      @$el = $(el)
      @isOpen = true
      @init()

    init: =>
      @$parent = @$el.parents '.section--accordion'
      @$body = @$parent.children '.section__body'

      @$el.on 'click', =>
        if @isOpen then @close() else @open()
        @$parent.toggleClass @options.classNames.VISIBILITY_CLASSES

    open: =>
      $(@$el).slideLeft 'fast'
      @isOpen = true

    close: =>
      $(@$el).slideRight 'fast'
      @isOpen = false

  $.fn.extend sideBar: (option, args...) ->
    @each ->
      $this = $(this)
      data = $this.data 'sideBar'

      if !data
        $this.data 'sideBar', (data = new Sidebar(this, option))

      if typeof option == 'string'
        data[option].apply(data, args)
