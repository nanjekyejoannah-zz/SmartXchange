class PostsController < ApplicationController
  include UsersHelper
  include PostsHelper

  before_action :vote_limit, only: [:upvote, :downvote]
  before_action :post_limit, only: [:create]

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      # in future may use js along with json to assign values to post.votes_count and post.votes_value_sum
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
    @post = Post.find(params[:id])
    if @post.update(post_params)
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
    @post = Post.find(params[:id])
    @post.destroy
    respond_to do |format|
      format.js
    end
  end

  def upvote
    @post = Post.includes(:votes).find(params[:id])
    @vote = Vote.new(value: 1, owner_id: current_user.id)
    @post.votes << @vote
    @up_votes = @post.votes.sum(:value)
    @total_votes = @post.votes.size
    create_post_notifications(@vote, @post)
    respond_to do |format|
      format.js
    end
  end

  def downvote
    @post = Post.includes(:votes).find(params[:id])
    @vote = Vote.new(value: -1, owner_id: current_user.id)
    @post.votes << @vote
    @up_votes = @post.votes.sum(:value)
    @total_votes = @post.votes.size
    create_post_notifications(@vote, @post)
    respond_to do |format|
      format.js
    end
  end

  def follow
    @post = Post.find(params[:id])
    @follow = Follow.new(follower_id: current_user.id)
    @post.follows << @follow
    create_post_notifications(@follow, @post)
    respond_to do |format|
      format.js
    end
  end

  def unfollow
    @post = Post.find(params[:id])
    # should be only 1 follows per person per post, may need to refactor
    @follow = @post.follows.where(follower_id: current_user.id).first
    @follow.destroy
    # if had one notification per follow could just call this as dependent destroy in follow model, wouldn't need it if didn't have unfollow
    destroy_post_notifications(@follow, @post)
    respond_to do |format|
      format.js
    end
  end

  def followers
    @post = Post.find(params[:id])
    @followers = @post.followers
    respond_to do |format|
      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit(:content, :board_id)
  end

  def vote_limit
    # limit to 10 votes per 24 hour time period
    @limit = 10
    if (current_user.votes.count >= @limit) && ((Time.now - current_user.votes.order(created_at: :desc).limit(@limit).last.created_at)/60/60/24 <= 1)
      respond_to do |format|
        format.js {render "vote_limit"}
      end
      return false
    end
    true
  end

  def post_limit
    @limit = 5
    if (current_user.posts.count >= @limit) && ((Time.now - current_user.posts.order(created_at: :desc).limit(@limit).last.created_at)/60/60/24 <= 1)
      respond_to do |format|
        format.js {render "post_limit"}
      end
      return false
    end
    true
  end

end
