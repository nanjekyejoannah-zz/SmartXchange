class CommentsController < ApplicationController
  include UsersHelper
  include PostsHelper

  before_action :comment_limit, only: [:create]

  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      # assuming that the comment is for a post, will have to add code if add comment on a comment
      @post = @comment.commentable
      create_notification(@comment, @post)
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js {render "errors"}
      end
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js {render "errors"}
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :commentable_type, :commentable_id)
  end

  def comment_limit
    @limit = 10
    if (current_user.comments.count >= @limit) && ((Time.now - current_user.comments.order(created_at: :desc).limit(@limit).last.created_at)/60/60/24 <= 1)
      respond_to do |format|
        format.js {render "comment_limit"}
      end
      return false
    end
    true
  end

  def create_notification(comment, post)
    @notification = nil
    if post_notification_check(post, comment)
      @notification = Notification.create!(
        notified_id: post.author.id,
        notifier_id: comment.author.id,
        notifiable_type: 'Post',
        notifiable_id: post.id,
        sourceable_type: 'Comment',
        sourceable_id: comment.id
      )
    end
    if !@notification.nil?
      WebNotificationsChannel.broadcast_to(
        post.author,
        post_notifications: user_count_unread_posts(post.author),
        total_notifications: user_count_unread(post.author),
        sound: true
      )
    end
  end

end
