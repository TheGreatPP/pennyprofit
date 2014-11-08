$LOAD_PATH << File.dirname(__FILE__)

require 'api'

run Rack::URLMap.new({
  "/" => PennyProfit::PennyProfitPublicApi,
  "/auth" => PennyProfit::PennyProfitAuthApi,
  "/api" => PennyProfit::PennyProfitSecureApi }
);
