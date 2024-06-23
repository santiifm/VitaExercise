# frozen_string_literal: true

module Api
  module V1
    class ClientsController < ApplicationController
      def create
        client = Client.new(client_params)
        if client.save
          render json: { message: 'Successfully created the client.', client: }, status: :created
        else
          render json: { error: client.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def transactions
        transactions = Client.find_by(id: params[:client_id])&.transactions

        if transactions
          render json: transactions, status: :ok
        else
          render json: { error: "Client doesn't exist or invalid client." }, status: :not_found
        end
      end

      private

      def client_params
        params.require(:client).permit(:username)
      end
    end
  end
end
