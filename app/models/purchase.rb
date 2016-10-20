# == Schema Information
#
# Table name: purchases
#
#  id         :integer          not null, primary key
#  buyer_id   :integer          not null
#  package_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Purchase < ApplicationRecord
  validates_presence_of :buyer, :package
  validates_uniqueness_of :buyer_id, scope: :package_id

  belongs_to :buyer, class_name: 'User'
  belongs_to :package

end
