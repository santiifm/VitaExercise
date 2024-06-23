# frozen_string_literal: true

module Api
  module V1
    class TransactionsController < ApplicationController
      def create
        source_amount = transaction_params[:source_amount].to_f
        source_balance = get_balance(params[:client_id], transaction_params[:source_currency])
        target_balance = get_balance(params[:client_id], transaction_params[:target_currency])

        if source_balance&.enough_funds(source_amount) && (target_amount = calculate_total).present?
          # Here the target amount is calculated later in order to avoid unnecesarily querying the CoinDesk API
          transaction = Transaction.new(transaction_params.merge(
                                          target_amount:,
                                          exchange_rate: @exchange_rate,
                                          client_id: params[:client_id]
                                        ))
        else
          return render json: { error: 'Not enough funds or invalid currencies.' }, status: :unprocessable_entity
        end

        if transaction.save
          update_balances(source_amount, source_balance, target_amount, target_balance)
          render json: { message: 'Successfully completed the transaction.',
                         transaction: format_tx(transaction) }, status: :created
        else
          render json: { error: transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        transaction = Transaction.find_by(id: params[:id])

        if transaction
          render json: format_tx(transaction), status: :ok
        else
          render json: { error: "Transaction doesn't exist or invalid transaction ID." }, status: :not_found
        end
      end

      private

      def transaction_params
        params.require(:transaction).permit(:source_currency, :target_currency, :source_amount)
      end

      # Gets the balance or creates one if first time dealing with that currency
      def get_balance(client_id, currency_type)
        ClientBalance.find_or_create_by(client_id:, currency_type:)
      end

      def update_balances(source_amount, source_balance, target_amount, target_balance)
        source_balance.update!(amount: source_balance.amount - source_amount)
        target_balance.update!(amount: target_balance.amount + target_amount)
      end

      # Returns total of transaction and selects the exchange rate
      def calculate_total
        if transaction_params[:source_currency] == 'BTC'
          set_exchange_rate(transaction_params[:target_currency])
          @exchange_rate * transaction_params[:source_amount] unless @exchange_rate.blank?
        else
          set_exchange_rate(transaction_params[:source_currency])
          @exchange_rate / transaction_params[:source_amount] unless @exchange_rate.blank?
        end
      end

      # Formats currency to have the international format
      def format_tx(transaction)
        transaction.target_amount = format_amount(transaction.target_currency, transaction.target_amount)
        transaction.source_amount = format_amount(transaction.source_currency, transaction.source_amount)
        transaction
      end

      def format_amount(type, amount)
        case type
        when 'USD'
          amount.round(2, :down)
        when 'BTC'
          amount.round(8, :down)
        end
      end

      def set_exchange_rate(currency)
        @exchange_rate = CoinDesk::GetExchangeRate.exec[currency]
      end
    end
  end
end
