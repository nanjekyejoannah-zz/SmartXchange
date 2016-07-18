jQuery(document).on 'turbolinks:load', ->
  messages = $('#messages')
  if $('#messages').length > 0
    messages_to_bottom = -> messages.scrollTop(messages.prop("scrollHeight"))

    messages_to_bottom()

    App.chat = App.cable.subscriptions.create {
        channel: "ChatRoomChannel"
        chat_room_id: messages.data('chat-room-id')
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
            @chat_room_id =  $("#messages").data('chat-room-id')
            @sender_id = $new_message.data('sender-id')
            # may need to refactor parseInt
            @current_user_id = parseInt($('meta[name=user-id]').attr("content"))
            if @current_user_id != @sender_id
              $new_message.removeClass("self").addClass("other")
              @perform 'update_notification', notified_id: @current_user_id, chat_room_id: @chat_room_id
            $('#messages').append($new_message)
            messages_to_bottom()
      send_message: (message,chat_room_id) ->
        console.log('chatroom - send_message')
        @perform 'send_message', message: message, chat_room_id: chat_room_id

    $('#new_message').submit (e) ->
      $this = $(this)
      textarea = $this.find('#message_body')
      if $.trim(textarea.val()).length > 1
        App.chat.send_message textarea.val(), messages.data('chat-room-id')
        textarea.val('')
      e.preventDefault()
      return false

    $(document).on 'keypress', (event) ->
      if event.keyCode is 13
        $('#new_message').submit()
        event.preventDefault()
