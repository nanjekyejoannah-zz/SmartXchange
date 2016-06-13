# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  name            :string           default("User"), not null
#  age             :integer          default(25), not null
#  language        :string           default("Spanish"), not null
#  language_level  :integer          default(5), not null
#  password_digest :string           not null
#  session_token   :string           not null
#  image           :string
#  active          :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string           default("Baller at Life"), not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
