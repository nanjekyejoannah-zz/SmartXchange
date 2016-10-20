# == Schema Information
#
# Table name: reviews
#
#  id              :integer          not null, primary key
#  reviewer_id     :integer          not null
#  reviewable_type :string           not null
#  reviewable_id   :integer          not null
#  chat_room_id    :integer          not null
#  language        :string           not null
#  language_level  :integer          not null
#  comment         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Review < ApplicationRecord
  validates_presence_of :reviewer, :reviewable, :chat_room, :language_level, :language
  # too long to have this database validation, only here
  # most validations are for instances when creating review from command line
  validates :language, uniqueness: { scope: [:reviewer_id, :reviewable_type, :reviewable_id], message: "You have already submitted a review for this user in this language, please check your reviews (in your user settings) and edit this review" }
  validates :chat_room_id, uniqueness: { scope: :reviewer_id, message: "You may only give one review per conversation" }
  validate :reviewer_not_reviewable
  validate :reviewer_in_chat_room
  # validating that association chat_room.user_reviews is 2 or less, only on create
  validate :user_reviews_length, on: :create

  belongs_to :reviewer, class_name: 'User'
  belongs_to :reviewable, polymorphic: true
  belongs_to :chat_room

  scope :between, -> (reviewer, reviewable, chat_room) do
    where("reviews.reviewer_id =? AND reviews.reviewable_type =? AND reviews.reviewable_id =? AND reviews.chat_room_id =?", reviewer.id, reviewable.class.name, reviewable.id, chat_room.id)
  end

  protected

  def reviewer_not_reviewable
    errors.add(:reviewer, "can not review him / her-self") if self.reviewer == self.reviewable
  end

  def user_reviews_length
    # chat_room association realized after save and therefore need >= 2
    errors.add(:chat_room_id, "can only have 2 reviews") if self.chat_room.user_reviews.size >= 2
  end

  def reviewer_in_chat_room
    errors.add(:reviewer_id, "did not participate in this conversation") unless (self.chat_room.initiator == self.reviewer || self.chat_room.recipient == self.reviewer)
  end

end
