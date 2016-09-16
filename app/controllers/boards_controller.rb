class BoardsController < ApplicationController
  include UsersHelper
  include PostsHelper

  def show
    @board = Board.first
    # refactor sql query, right now orders by sum(value) then updated_at, also assuming all posts are associated with the first board, and all comments are for post
    # @posts = Post.includes().joins(:votes).select('votable_id, count(votable_id) as votes_count, sum(value) as votes_value_sum').group(:votable_id).order('sum(value) desc')
    # coalesce because postgres does not return sum of empty column
    @posts = Post.find_by_sql("
      select *
      from posts
      left join (
        select votable_id, count(votable_id) as votes_count, coalesce(sum(value),0) as votes_value_sum
        from votes
        group by votable_id
      ) as sums on
      posts.id = sums.votable_id
      order by sums.votes_value_sum, posts.updated_at").reverse
      # only way to get includes to work on the array returned from the sql statement above, maybe refactor don't need all followers information
      ActiveRecord::Associations::Preloader.new.preload(@posts, [:owner, :comments, {comments: :owner}, :followers])
    if user_count_unread_posts(current_user) > 0
      @notification = user_first_unread_post(current_user)
      # maybe refactor this and chat_room_mark_read to notification_mark_read, and delete notification
      post_mark_read(@notification)
    end
  end

end
