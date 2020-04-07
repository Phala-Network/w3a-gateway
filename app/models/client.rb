# frozen_string_literal: true

class Client < ApplicationRecord
  has_many :site_clients, foreign_key: :cid, primary_key: :fingerprint
  has_many :sites, through: :site_clients

  has_many :page_views, foreign_key: :cid, primary_key: :fingerprint

  has_many :client_contracts
  has_many :contracts, through: :client_contracts
end
