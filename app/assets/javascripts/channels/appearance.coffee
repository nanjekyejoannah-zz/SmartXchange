App.appearance = App.cable.subscriptions.create "AppearanceChannel",
  # Called when the subscription is ready for use on the server
  connected: ->
    console.log('appearance - connected')
    # @install()
    @appear()

  # Called when the WebSocket connection is closed
  disconnected: ->
    console.log('appearance - disconnected')
    @disappear()


    # @uninstall()

  # Called when the subscription is rejected by the server
  # rejected: ->
  #   @uninstall()

  appear: ->
    # Calls `AppearanceChannel#appear(data)` on the server
    console.log('appear')
    @perform("appear")
    # , appearing_on: $("main").data("appearing-on")

  disappear: ->
    # Calls `AppearanceChannel#disappear` on the server
    console.log('disappear')
    @perform("disappear")
  # install: ->
  #
  #
  # uninstall: ->
    # $(document).off(".appearance")
    # $(buttonSelector).hide()

  # buttonSelector = "[data-behavior~=appear_away]"

# $(document).on "page:change.appearance", =>
#   console.log('install')
#   App.appearance.appear()
  # @appear()

# $(document).on "click.appearance", buttonSelector, =>
#   @disappear()
#   false
#
# $(buttonSelector).show()
