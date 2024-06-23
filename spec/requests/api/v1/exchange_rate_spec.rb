require 'swagger_helper'

RSpec.describe 'api/v1/exchange_rates', type: :request do
  path '/api/v1/exchange_rates' do
    get('Retrieve exchange rate') do
      consumes 'application/json'
      produces 'application/json'

      response(200, 'Success') do
        examples 'application/json' => {
          'USD' => 64_383.6143
        }

        run_test! do |response|
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to include('USD')
        end
      end

      response(503, 'Service Unavailable') do
        before do
          allow(CoinDesk::GetExchangeRate).to receive(:exec).and_return({ error: 'CoinDesk API is currently unavailable' })
        end

        examples 'application/json' => {
          error: 'CoinDesk API is currently unavailable'
        }

        run_test! do |response|
          expect(response.status).to eq(503)
          expect(JSON.parse(response.body)['error']).to eq('CoinDesk API is currently unavailable')
        end
      end
    end
  end
end
