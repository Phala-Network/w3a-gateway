# frozen_string_literal: true

class SiteClient < ApplicationRecord
  belongs_to :site

  # validates :cid,
  #           presence: true,
  #           uniqueness: { scope: :site }
end
