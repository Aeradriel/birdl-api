class ApiKey < ActiveRecord::Base
  before_create :generate_access_token

  belongs_to :user

  private

  # Generate an access token with a duration
  # User has to be set manually
  def generate_access_token
    begin
      self.access_token = SecureRandom.uuid.gsub(/\-/,'')
      self.available = 3600
    end while self.class.exists?(access_token: access_token)
  end
end
