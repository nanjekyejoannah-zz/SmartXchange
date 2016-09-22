class BoardsController < ApplicationController
  include UsersHelper
  include PostsHelper
  include BoardsHelper

  def show
    @board = Board.first
    # refactor sql query, right now orders by sum(value) then updated_at, also assuming all posts are associated with the first board, and all comments are for post, group by just v.votable_id (ok in sql but not pg) is faster
    # @posts = Post.includes().joins(:votes).select('votable_id, count(votable_id) as votes_count, sum(value) as votes_value_sum').group(:votable_id).order('sum(value) desc')
    # coalesce because postgres does not return sum of empty column
    @posts = Post.find_by_sql("
      select p.*, v.votable_id, count(v.votable_id) as votes_count, coalesce(sum(v.value),0) as votes_value_sum
      from posts p
      left join votes v on p.id = v.votable_id
      group by p.id, v.votable_id
      order by votes_value_sum desc, p.updated_at desc")
      # only way to get includes to work on the array returned from the sql statement above, maybe refactor don't need all followers information
      ActiveRecord::Associations::Preloader.new.preload(@posts, [:owner, :comments, {comments: :owner}, :followers])
    if user_count_unread_posts(current_user) > 0
      @notification = user_first_unread_post(current_user)
      # maybe refactor this and chat_room_mark_read to notification_mark_read, and delete notification
      post_mark_read(@notification)
    end
    # maybe refactor later, only update user if he/she is viewing unread posts, add +1 to current user due to delay in updating associations through touch
    if board_has_unread?(@board)
      board_mark_read
    end
  end

end
