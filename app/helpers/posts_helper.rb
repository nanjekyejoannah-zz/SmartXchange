module PostsHelper

  def post_mark_read(notification)
    # only notifications pertaining to post here - like comment and vote notifications, may want to refactor and move this into notification helper to make this sql faster by something like user.notification.where
    notification.update(read: true)
  end

  def post_notification_check(vote_or_comment_or_follow_or_post_update, post, follower =  nil)
    # always create notification for comment, but only 1 new notification if it's a vote or a follow
    # maybe refactor, right now if a person updates comment more than once more than one notification will be created
    return true if vote_or_comment_or_follow_or_post_update.is_a?(Comment)
    notified = follower ? follower : post.owner
    return false if vote_or_comment_or_follow_or_post_update.is_a?(Vote) && post.notifications.where(read: false, notified_id: notified.id, sourceable_type: 'Vote').count > 0
    return false if vote_or_comment_or_follow_or_post_update.is_a?(Follow) && post.notifications.where(read: false, notified_id: notified.id, sourceable_type: 'Follow').count > 0
    return false if vote_or_comment_or_follow_or_post_update.is_a?(Post) && post.notifications.where(read: false, notified_id: notified.id, sourceable_type: 'Post').count > 0
    true
  end


end
