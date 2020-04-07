# frozen_string_literal: true

class ClientContract < ApplicationRecord
  belongs_to :contract
  belongs_to :client
end
