# frozen_string_literal: true

class Client < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  has_many :transactions
  has_many :client_balances
end
