# frozen_string_literal: true

class ContractGroup < ApplicationRecord
  has_many :contracts, foreign_key: :group_id
end
