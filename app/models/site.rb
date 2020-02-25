# frozen_string_literal: true

class Site < ApplicationRecord
  belongs_to :creator, class_name: "User"

  has_many :online_users_reports, dependent: :delete_all

  validates :sid, :domain,
            presence: true,
            uniqueness: true

  after_initialize :initialize_attributes, if: :new_record?

  scope :verified, -> { where verified: true }

  private

    def initialize_attributes
      self.sid ||= SecureRandom.hex(4)
    end
end
