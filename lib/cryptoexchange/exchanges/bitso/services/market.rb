module Cryptoexchange::Exchanges
  module Bitso
    module Services
      class Market < Cryptoexchange::Services::Market
        class << self
          def supports_individual_ticker_query?
            true
          end
        end

        def fetch(market_pair)
          output = super(ticker_url(market_pair))
          adapt(output, market_pair)
        end

        def ticker_url(market_pair)
          base = market_pair.base.downcase
          target = market_pair.target.downcase
          "#{Cryptoexchange::Exchanges::Bitso::Market::API_URL}/ticker?book=#{base}_#{target}"
        end

        def adapt(output, market_pair)
          market = output['payload']
          ticker = Cryptoexchange::Models::Ticker.new
          ticker.base = market_pair.base
          ticker.target = market_pair.target
          ticker.market = Bitso::Market::NAME
          ticker.ask = NumericHelper.to_d(market['ask'])
          ticker.bid = NumericHelper.to_d(market['bid'])
          ticker.last = NumericHelper.to_d(market['last'])
          ticker.high = NumericHelper.to_d(market['high'])
          ticker.low = NumericHelper.to_d(market['low'])
          ticker.volume = NumericHelper.to_d(market['volume'])
          ticker.timestamp = DateTime.parse(market['created_at']).to_time.to_i
          ticker.payload = market
          ticker
        end
      end
    end
  end
end
