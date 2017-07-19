class User < ApplicationRecord
  before_save :generate_auth_token

  private

  def generate_auth_token
    self.auth_token = SecureRandom.hex
  end
end
