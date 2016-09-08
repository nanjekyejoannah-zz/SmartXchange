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
    unread_chat_rooms = if (data['chat_room_notifications'] && data['chat_room_notifications'] > 0) then " (#{data['chat_room_notifications']})" else ""
    unread_posts = if (data['post_notifications'] && data['post_notifications'] > 0) then " (#{data['post_notifications']})" else ""
    unread_total = if data['total_notifications'] > 0 then "(#{data['total_notifications']})" else ""
    $('title')[0].innerHTML = "#{unread_total} smartXchange"
    $('#chat-rooms-header a')[0].innerHTML = "Chat Rooms #{unread_chat_rooms}"
    $('#board-header a')[0].innerHTML = "Board #{unread_posts}"
    $('#chatAudio')[0].play() if data['sound']
    # hack job to refresh page if user is on the chat room / index page, maybe refactor later
    if $('#chat-rooms').length
      location.reload();
