# == Schema Information
#
# Table name: linkedins
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  public_url :string
#  industry   :string
#  summary    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Linkedin < ApplicationRecord
  # currently no way of displaying error if this happens, but buttons should only appear in cases where this can't happen
  validates :user_id, uniqueness: true

  belongs_to :user

end
