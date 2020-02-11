# frozen_string_literal: true

class Site < ApplicationRecord
  belongs_to :creator, class_name: "User"

  validates :sid, :domain,
            presence: true,
            uniqueness: true

  after_initialize :initialize_attributes, if: :new_record?

  private

    def initialize_attributes
      self.sid ||= SecureRandom.hex(4)
    end
end
