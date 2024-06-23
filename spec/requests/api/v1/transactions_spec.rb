require 'swagger_helper'

RSpec.describe 'api/v1/transactions', type: :request do
  path '/api/v1/transactions' do
    post('Create a Transaction') do
      tags 'Transactions'
      consumes 'application/json'
      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          source_currency: { type: :string },
          target_currency: { type: :string },
          source_amount: { type: :number },
          client_id: { type: :integer }
        },
        required: %w[source_currency target_currency source_amount client_id]
      }

      response(201, 'Transaction Created') do
        let(:client) { Client.create!(username: 'testuser') }
        let(:transaction) do
          { source_currency: 'USD', target_currency: 'BTC',
            source_amount: 100.0, client_id: client.id }
        end

        examples 'application/json' => {
          id: 1,
          source_currency: 'USD',
          target_currency: 'BTC',
          source_amount: 123.12345,
          target_amount: 567.64334123,
          client_id: 1,
          exchange_rate: 123.00,
          created_at: '2024-06-23T21:50:51.991Z',
          updated_at: '2024-06-23T21:50:51.991Z'
        }

        run_test! do
          parsed_response = JSON.parse(response.body)
          transaction_keys = parsed_response['transaction'].keys
          expected_keys = %w[client_id created_at exchange_rate id source_amount source_currency
                             target_amount target_currency updated_at]

          expect(response.status).to eq(201)
          expect(parsed_response).to be_an_instance_of(Hash)
          expect(parsed_response.keys).to contain_exactly('message', 'transaction')
          expect(transaction_keys).to contain_exactly(*expected_keys)
        end
      end

      response '422', 'invalid request' do
        let(:client) { Client.create!(username: 'testuser') }
        let(:transaction) do
          { source_currency: 'BTC', target_currency: 'BTC',
            source_amount: 100.0, client_id: client.id }
        end
        run_test! do
          expect(response.status).to eq(422)
          expect(JSON.parse(response.body)['error']).to eq('Not enough funds or invalid currencies.')
        end
      end

      response '422', 'invalid request' do
        let(:client) { Client.create!(username: 'testuser') }
        let(:transaction) do
          { source_currency: 'USD', target_currency: 'BTC',
            source_amount: 100.0, client_id: 2 }
        end
        run_test! do
          expect(response.status).to eq(422)
          expect(JSON.parse(response.body)['error']).to eq(['Client must exist'])
        end
      end
    end
  end

  path '/api/v1/transactions/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('Get a specific transaction') do
      tags 'Transactions'
      produces 'application/json'
      response '200', 'transaction found' do
        let(:client) { Client.create!(username: 'testuser') }
        let(:transaction) {
          Transaction.create(
            source_currency: 'USD',
            target_currency: 'BTC',
            source_amount: 100.0,
            target_amount: 638.092127,
            exchange_rate: 63_809.2127,
            client_id: client.id
          )
        }
        let(:id) { transaction.id }

        examples 'application/json' => {
          id: 1,
          source_currency: 'USD',
          target_currency: 'BTC',
          source_amount: 123.12345,
          target_amount: 567.64334123,
          client_id: 1,
          exchange_rate: 123.00,
          created_at: '2024-06-23T21:50:51.991Z',
          updated_at: '2024-06-23T21:50:51.991Z'
        }

        run_test! do
          parsed_response = JSON.parse(response.body)

          expect(response.status).to eq(200)
          expect(parsed_response).to be_an_instance_of(Hash)
        end
      end

      response '404', 'transaction not found' do
        let(:id) { 'invalid' }

        run_test! do
          expect(response.status).to eq(404)
          expect(JSON.parse(response.body)['error']).to eq("Transaction doesn't exist or invalid transaction ID.")
        end
      end
    end
  end
end
