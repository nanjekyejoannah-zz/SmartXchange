App.web_notifications = App.cable.subscriptions.create "WebNotificationsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log('web_notifications - connected')

  disconnected: ->
    # Called when the subscription has been terminated by the server
    console.log('web_notifications - disconnected')

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    # Client-side which assumes you've already requested
    console.log('web_notifications - received')
    # may need to refactor this
    unread = if data['notifications'] > 0 then "(#{data['notifications']})" else ""
    $('title')[0].innerHTML = "#{unread} smartXchange"
    $('.chat-rooms-header a')[0].innerHTML = "Chat Rooms #{unread}"
    $('#chatAudio')[0].play() if data['sound']
