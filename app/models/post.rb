# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  author_id  :integer          not null
#  board_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ApplicationRecord
  validates_presence_of :author_id, :board_id, :content
  validates :content, length: {minimum: 5, maximum: 255}

  belongs_to :author, class_name: 'User'
  belongs_to :board
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  default_scope -> { order(updated_at: :desc) } 


  def timestamp
    created_at.strftime('%H:%M:%S %d %B %Y')
  end

  def add_attributes
    @votes_sum = self.votes.count
    @votes_value_sum = self.votes.sum(:value)
  end

end
