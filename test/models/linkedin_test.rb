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

require 'test_helper'

class LinkedinTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
