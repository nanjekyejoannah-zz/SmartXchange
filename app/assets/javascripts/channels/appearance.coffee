App.appearance = App.cable.subscriptions.create "AppearanceChannel",
  # Called when the subscription is ready for use on the server
  connected: ->
    # console.log('appearance - connected')
    # @install()
    @appear()

  # Called when the WebSocket connection is closed
  disconnected: ->
    # console.log('appearance - disconnected')
    @disappear()


  appear: ->
    # Calls `AppearanceChannel#appear(data)` on the server
    # console.log('appear')
    @perform("appear")
    # , appearing_on: $("main").data("appearing-on")

  disappear: ->
    # Calls `AppearanceChannel#disappear` on the server
    # console.log('disappear')
    @perform("disappear")
