# == Schema Information
#
# Table name: reads
#
#  id            :integer          not null, primary key
#  user_id       :integer          not null
#  readable_type :string
#  readable_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Read < ApplicationRecord
  validates_uniqueness_of :user_id, :scope => [:readable_type, :readable_id]
  belongs_to :user
  belongs_to :readable, polymorphic: true
end
