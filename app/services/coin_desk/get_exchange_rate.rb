# frozen_string_literal: true

require 'uri'
require 'net/http'

module CoinDesk
  class GetExchangeRate < ApplicationService
    # Method that queries the CoinDesk API and then returns the current exchange rate of BTC in USD/EUR/GBP
    def exec
      uri = URI("https://api.coindesk.com/v1/bpi/currentprice.json")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri)
      response = http.request(request)

      if response.is_a? Net::HTTPSuccess
        # Returns bpi which are the exchange rates
        JSON.parse(response.body)['bpi'].transform_values { |v| v["rate_float"] }
      else
        { error: "#{response.code} #{response.read_body}" }
      end
    end

    def headers
      {
        'content-type': 'application/json',
        'cache-control': 'no-cache',
      }
    end
  end
end
