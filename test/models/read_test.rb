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

require 'test_helper'

class ReadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
