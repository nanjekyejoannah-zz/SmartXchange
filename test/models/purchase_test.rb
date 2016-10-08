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

require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
