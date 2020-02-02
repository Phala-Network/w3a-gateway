# frozen_string_literal: true

class User < ApplicationRecord
  has_many :sites, foreign_key: "owner_id"

  has_many :access_requests, dependent: :delete_all
  has_many :access_tokens, dependent: :delete_all do
    def active
      where("expires_at > ? AND revoked_at IS NULL", Time.zone.now)
    end
  end

  attr_readonly :email, :public_key

  validates :email,
            presence: true,
            format: {
              with: /\A[^@\s]+@[^@\s]+\z/
            },
            uniqueness: true

  validates :public_key,
            presence: true,
            uniqueness: true

  def activated?
    activated_at.present?
  end

  def enabled?
    activated_at.present? && disabled_at.blank?
  end

  def disabled?
    disabled_at.present?
  end

  def disable!
    return if disabled?

    disabled_at = Time.now.utc

    transaction do
      access_requests.pending.delete_all
      access_tokens.where(revoked_at: nil).update_all revoked_at: disabled_at
      update_attribute :disabled_at, disabled_at
    end

    self
  end

  def enable!
    return unless disabled?

    update_attribute :disabled_at, nil

    self
  end
end
