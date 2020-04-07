# frozen_string_literal: true

class Contract < ApplicationRecord
  belongs_to :group, class_name: "ContractGroup"

  has_many :contract_subscriptions
  has_many :sites, through: :contract_subscriptions

  has_many :client_contracts
  has_many :clients, through: :client_contracts
end
