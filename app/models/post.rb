# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  owner_id   :integer          not null
#  board_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ApplicationRecord
  validates_presence_of :owner_id, :board_id, :content
  validates :content, length: {minimum: 5, maximum: 255}

  belongs_to :owner, class_name: 'User', touch: true
  belongs_to :board, touch: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :follows, as: :followable, dependent: :destroy
  has_many :followers, through: :follows

  default_scope -> { order(updated_at: :desc) }


  def timestamp
    created_at.strftime('%H:%M:%S %d %B %Y')
  end

end
