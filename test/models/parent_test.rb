# == Schema Information
#
# Table name: parents
#
#  id                     :integer          not null, primary key
#  name                   :string
#  phone                  :string
#  home_address           :text
#  occupation             :string
#  monthly_income         :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  username               :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  gender                 :string
#

require 'test_helper'

class ParentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
