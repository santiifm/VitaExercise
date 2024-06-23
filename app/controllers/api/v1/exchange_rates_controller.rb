# frozen_string_literal: true

module Api
  module V1
    class ExchangeRatesController < ApplicationController
      def index
        exchange_rate = CoinDesk::GetExchangeRate.exec
        if !exchange_rate.key?(:error)
          render json: exchange_rate, status: :ok
        else
          render json: exchange_rate, status: :service_unavailable
        end
      end
    end
  end
end
