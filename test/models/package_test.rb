# == Schema Information
#
# Table name: packages
#
#  id             :integer          not null, primary key
#  classification :string           not null
#  description    :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  price          :decimal(8, 2)
#

require 'test_helper'

class PackageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
