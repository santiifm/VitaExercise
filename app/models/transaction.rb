# frozen_string_literal: true

class Transaction < ApplicationRecord
  ALLOWED_CURRENCIES = ['USD', 'BTC'].freeze
  belongs_to :client
  validates :source_currency, :target_currency, inclusion: { in: ALLOWED_CURRENCIES, message: '%{value} is not a valid currency' }
  validates :source_currency, :source_amount, :target_currency, :target_amount, :client_id, :exchange_rate, presence: true
end
