class User < ApplicationRecord
  attr_accessor :remember_token
  before_save :downcase_email
  before_create :remember

  has_many :posts

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  #Returns the hash digest of the given string
  def self.digest(string)
    Digest::SHA1.hexdigest(string)
  end

  #returns a random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  #remembers a user in the databse for use in persistent sessions
  def remember
    begin
      self.remember_token = User.new_token
      self.remember_digest = User.digest(remember_token)
    end while User.exists?(remember_digest: self.remember_digest)
  end

  #returns true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    digest == User.digest(token)
  end

  #forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  private

    #converts the email to all lower case
    def downcase_email
      email.downcase!
    end
end
