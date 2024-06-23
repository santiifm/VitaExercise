# frozen_string_literal: true

class ClientBalance < ApplicationRecord
  ALLOWED_CURRENCIES = ['USD', 'BTC'].freeze
  belongs_to :client
  validates :currency_type, inclusion: { in: ALLOWED_CURRENCIES, message: '%{value} is not a valid currency' }

  def enough_funds(transaction_amount)
    transaction_amount <= amount
  end
end
