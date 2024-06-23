require 'swagger_helper'

RSpec.describe 'api/v1/exchange_rates', type: :request do
  path '/api/v1/exchange_rates' do
    get('Retrieve exchange rate') do
      consumes 'application/json'
      produces 'application/json'

      response(200, 'Success') do
        examples 'application/json' => {
          'USD' =>
            { 'code' => 'USD',
              'symbol' => '&#36;',
              'rate' => '64,383.614',
              'description' => 'United States Dollar',
              'rate_float' => 64_383.6143 },
          'GBP' =>
          { 'code' => 'GBP',
            'symbol' => '&pound;',
            'rate' => '50,882.048',
            'description' => 'British Pound Sterling',
            'rate_float' => 50_882.0484 },
          'EUR' =>
          { 'code' => 'EUR',
            'symbol' => '&euro;',
            'rate' => '60,213.81',
            'description' => 'Euro',
            'rate_float' => 60_213.8095 }
        }

        run_test! do |response|
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to include('USD', 'EUR', 'GBP')
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
