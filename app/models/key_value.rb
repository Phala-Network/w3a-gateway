# frozen_string_literal: true

class KeyValue < ApplicationRecord
  enum value_type: {
    integer: 1,
    datetime: 2,
    string: 3
  }

  validates :key,
            presence: true,
            uniqueness: true
  validates :value_type,
            presence: true

  def value
    case value_type
    when "integer"
      integer_value
    when "datetime"
      datetime_value
    when "string"
      string_value
    else
      raise "Unknown type - #{value_type}"
    end
  end

  def value=(v)
    case value_type
    when "integer"
      self.integer_value = v
    when "datetime"
      self.datetime_value = v
    when "string"
      self.string_value = v
    else
      raise "Unknown type - #{value_type}"
    end
  end
end
