# frozen_string_literal: true

class AccessToken < ApplicationRecord
  EXPIRES_IN = 1.days

  belongs_to :user
  belongs_to :access_request, optional: true

  scope :active, -> { where("expires_at > ? AND revoked_at IS NULL", Time.now) }

  after_initialize :initialize_attributes, if: :new_record?

  validates :token, :refresh_token,
            presence: true,
            uniqueness: true

  def revoked?
    revoked_at
  end

  def expired?
    expires_at && expires_at < Time.now
  end

  def regenerate_token!
    generate_token
    save validate: false
  end

  def extend_token!
    update_attribute :expires_at, Time.now + EXPIRES_IN
  end

  private

    def generate_token
      self.token = SecureRandom.uuid.delete("-")
      self.expires_at = Time.now + EXPIRES_IN
    end

    def initialize_attributes
      self.refresh_token = SecureRandom.uuid.delete("-")
      generate_token
    end
end
