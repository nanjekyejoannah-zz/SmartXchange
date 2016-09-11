# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  read            :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notified_id     :integer
#  notifier_id     :integer
#  notifiable_type :string
#  notifiable_id   :integer
#  sourceable_type :string
#  sourceable_id   :integer
#

class Notification < ApplicationRecord
  validates_presence_of :notified_id, :notifier_id, :notifiable, :sourceable

  belongs_to :notified, class_name: 'User'
  belongs_to :notifier, class_name: 'User'
  # touch: true should update the associated post or chat room updated_at
  belongs_to :notifiable, polymorphic: true
  belongs_to :sourceable, polymorphic: true

  default_scope -> { order(created_at: :asc) }

end
