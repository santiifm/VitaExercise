# frozen_string_literal: true

class Client < ApplicationRecord
  has_many :transactions
  has_many :client_balances
end
