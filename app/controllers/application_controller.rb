# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from SQLite3::BusyException do
    ActiveRecord::Base.connection.execute("BEGIN TRANSACTION; END;")
  end
end
