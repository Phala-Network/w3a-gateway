# frozen_string_literal: true

class AccessRequest < ApplicationRecord
  EXPIRES_IN = Rails.env.production? ? 1.minutes : 10.minutes

  belongs_to :user

  has_one :access_token

  scope :pending, -> { where(granted_at: nil).where("expires_at > ?", Time.now) }

  after_initialize :initialize_attributes, if: :new_record?

  validates :request_token,
            presence: true,
            uniqueness: true

  def granted?
    granted_at
  end

  def expired?
    expires_at && expires_at < Time.now
  end

  def grant!
    transaction do
      update_attribute :granted_at, Time.now

      create_access_token! user: user
    end
  end

  private

    def initialize_attributes
      self.request_token = SecureRandom.uuid.delete("-")
      self.expires_at = Time.now + EXPIRES_IN
    end
end
