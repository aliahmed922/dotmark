# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  subdomain     :string
#  resource_type :string
#  resource_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  is_active     :boolean          default(FALSE)
#

class Account < ActiveRecord::Base
	belongs_to :resource, polymorphic: true, dependent: :delete
	# validates_uniqueness_of :resource_id
	validates_uniqueness_of :subdomain
  CurrentPassword = "Warning: Current Password must be filled."
	# include ActiveModel::Serializers::JSON

  # def attributes=(hash)
  #   hash.each do |key, value|
  #     send("#{key}=", value)
  #   end
  # end

  # def attributes
  #   instance_values
  # end
end
