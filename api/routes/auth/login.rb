module PennyProfit
  class PennyProfitAuthApi < PennyProfitApiBase
    
    get "/login" do
      success_response({transactions: "123"})
    end

    post "/login" do
    	#Validate credentials
    	params[:credentials]

    	success_response({auth_key: "random auth key"})
    end
    
  end
end
