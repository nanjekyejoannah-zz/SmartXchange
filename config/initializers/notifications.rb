
# not using regex because regex is quite slow
# can be used for checking page load speeds and controller action speeds, etc
# ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
#   data = args.extract_options!
#   if (data[:controller] == "MessagesController") & (data[:action] == "create")
#       sender = User.find_by_id(data[:params]["message"]["sender_id"])
#       chat = Chat.find_by_id(data[:params]["chat_id"])
#       # notify(sender)
#   end
# end

# Used for checking on appearance channel
# ActiveSupport::Notifications.subscribe /Rendered/ do |*args|
#   data = args.extract_options!
#   p data
# end


# any time there is a database query to update active would like to reload dom
