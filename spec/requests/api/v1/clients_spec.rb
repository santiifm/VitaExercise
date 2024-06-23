require 'swagger_helper'

RSpec.describe 'api/v1/clients', type: :request do
  path '/api/v1/clients/{client_id}/transactions' do
    get("Get a client's transactions") do
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'client_id', in: :path, type: :string, description: 'client_id'

      response(200, 'Success') do
        let(:client) { Client.create!(username: 'testuser') }
        let!(:transaction) {
          Transaction.create!(
            source_currency: 'USD', target_currency: 'BTC',
            source_amount: 123.12345, target_amount: 567.64334123,
            client_id: client.id, exchange_rate: 123.00
          )
        }
        let(:client_id) { client.id }

        examples 'application/json' => [
          {
            id: 1,
            source_currency: 'USD',
            target_currency: 'BTC',
            source_amount: 123.12345,
            target_amount: 567.64334123,
            client_id: 1,
            exchange_rate: 123.00
          }
        ]

        run_test! do
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to be_an_instance_of(Array)
          expect(JSON.parse(response.body).first['id']).to eq(transaction.id)
        end
      end

      response(404, 'Not found') do
        let(:client_id) { 'invalid' }

        examples 'application/json' => {
          error: "Client doesn't exist or invalid client."
        }

        run_test! do |response|
          expect(response.status).to eq(404)
          expect(JSON.parse(response.body)['error']).to eq("Client doesn't exist or invalid client.")
        end
      end
    end
  end

  path '/api/v1/clients' do
    post('Create a client') do
      consumes 'application/json'
      produces 'application/json'
      parameter name: :client, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string }
        },
        required: ['username']
      }, description: 'Client object containing username'

      response(201, 'Created') do
        let(:client) { { username: 'testuser' } }

        examples 'application/json' => {
          message: 'Successfully created the client.'
        }

        run_test! do |response|
          expect(response.status).to eq(201)
          expect(JSON.parse(response.body)['message']).to eq('Successfully created the client.')
        end
      end

      response(422, 'Unprocessable Entity') do
        let(:client) { { username: nil } }

        examples 'application/json' => {
          error: ["Username can't be blank"]
        }

        run_test! do |response|
          expect(response.status).to eq(422)
          expect(JSON.parse(response.body)['error']).to be_present
        end
      end
    end
  end
end
