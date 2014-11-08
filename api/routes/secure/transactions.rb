module PennyProfit
  class PennyProfitSecureApi < PennyProfitApiBase
    
    get "/transactions" do
      success_response({transactions: "123"})
    end
    
  end
end
