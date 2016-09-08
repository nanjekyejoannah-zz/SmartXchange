module PostsHelper

  def post_mark_read(notification)
    # only notifications pertaining to post here - like comment and vote notifications, may want to refactor and move this into notification helper to make this sql faster by something like user.notification.where
    notification.update(read: true)
  end

  # Ensures only 1 notification is created per new message(s) created and won't be notified if you comment / vote on your own post
  def post_notification_check(post, vote_or_comment)
    notifier = vote_or_comment.is_a?(Comment) ? vote_or_comment.author : vote_or_comment.owner
    return false if post.author ==  notifier
    # always create notification for comment, but only 1 new notification if it's a vote
    return true if vote_or_comment.is_a?(Comment)
    return false if post.notifications.where(read: false, notified_id: post.author.id).count > 0
    true
  end

end
