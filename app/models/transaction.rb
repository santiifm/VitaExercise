# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :client
  validates :source_currency, :source_amount, :target_currency, :target_amount, :client_id, :exchange_rate, presence: true
end
