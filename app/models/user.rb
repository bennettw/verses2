# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string(255)
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  has_many :passages

  def to_param
    'foo'
  end

  acts_as_authentic do |config|
    #config.crypto_provider = Authlogic::CryptoProviders::Sha256
  end
end
