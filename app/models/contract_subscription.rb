# frozen_string_literal: true

class ContractSubscription < ApplicationRecord
  belongs_to :contract
  belongs_to :site

  enum status: {
    in_use: "in_use",
    not_in_use: "not_in_use"
  }

  after_initialize if: :new_record? do
    self.status ||= "in_use"
  end

  validates :site,
            presence: true,
            uniqueness: { scope: :contract }
  validates :contract,
            presence: true
end
