# frozen_string_literal: true

class Site < ApplicationRecord
  belongs_to :creator, class_name: "User"

  validates :uid, :domain,
            presence: true,
            uniqueness: true

  after_initialize :initialize_attributes, if: :new_record?

  private

    def initialize_attributes
      self.uid ||= SecureRandom.hex(4)
    end
end
