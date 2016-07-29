jQuery(document).on 'turbolinks:load', ->
  $messages = $('#messages')
  $title = $('title')[0]
  if $('#messages').length > 0
    messages_to_bottom = -> $messages.scrollTop($messages.prop("scrollHeight"))

    messages_to_bottom()

    App.chat = App.cable.subscriptions.create {
        channel: "ChatRoomChannel"
        chat_room_id: $messages.data('chat-room-id')
      },
      connected: ->
        # Called when the subscription is ready for use on the server
        console.log('chatroom - connected')
        messages_to_bottom()
      disconnected: ->
        # Called when the subscription has been terminated by the server
        console.log('chatroom - disconnected')
      received: (data) ->
        # Called when there's incoming data on the websocket for this channel
          console.log('chatroom - received')

          $last_message = $("#messages .message").last()
          $new_message = $(data['message'])
          # to prevent repeat messages broadcasted may need to refactor later
          if $last_message.data('message-id') != $new_message.data('message-id')
            @sender_id = $new_message.data('sender-id')
            @current_user_id = parseInt($('meta[name=user-id]').attr("content"))
            if @current_user_id != @sender_id
              $new_message.removeClass("self").addClass("other")
              # may need to refactor this
              @count = if /[1-9]/.test($title.innerHTML) then (parseInt($title.innerHTML.match(/[1-9]/)[0]) + 1) else 1;
              $('title')[0].innerHTML = "(#{@count}) smartXchange"
              $('.chats-header a')[0].innerHTML = "Chat Rooms (#{@count})"
            $messages.append($new_message)
          messages_to_bottom()
      send_message: (message,chat_room_id) ->
        console.log('chatroom - send_message')
        @perform 'send_message', message: message, chat_room_id: chat_room_id
      update_notification: ->
        # may need to refactor basically saying update notification if receiver
        @chat_room_id =  $messages.data('chat-room-id')
        @current_user_id = parseInt($('meta[name=user-id]').attr("content"))
        $last_message = $("#messages .message").last()
        if $last_message.data('sender-id') != @current_user_id
          @perform 'update_notification', notified_id: @current_user_id, chat_room_id: @chat_room_id

    $('#new_message').submit (e) ->
      $this = $(this)
      textarea = $this.find('#message-body')
      if $.trim(textarea.val()).length > 1
        App.chat.send_message textarea.val(), $messages.data('chat-room-id')
        textarea.val('')
      e.preventDefault()
      return false
    $(document).on 'keypress', (event) ->
      if event.keyCode is 13
        $('#new_message').submit()
        event.preventDefault()
    $('.send-message').on 'click', (event) ->
      $('#new_message').submit()
      event.preventDefault()
    # may need to refactor anytime user clicks on textarea notifications for this chat room and current_user are gone
    $('#message-body').on 'focus', (event) ->
      App.chat.update_notification()
      event.preventDefault()
