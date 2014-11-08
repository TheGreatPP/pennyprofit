require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/cross_origin'
require 'rack/contrib/post_body_content_type_parser'
require 'config/api_initializer'
require 'active_support/core_ext'
require 'api/routes/route_support'

module PennyProfit

  module PennyProfitApi
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, PennyProfit::ApiInitializer)
    end

    module ClassMethods
      def load_config(options = {})
        options = { include: [:route_support] }.reverse_merge(options)
        run_initializer options do
          include RouteSupport
        end
      end
    end
  end

  class PennyProfitApiBase < Sinatra::Base
    use Rack::PostBodyContentTypeParser
    include PennyProfitApi

    #disables errors from propogating outside the app and allows the error handler to manage errors
    disable :raise_errors
    error do
      handle_error_response env['sinatra.error']
    end
  end

  class PennyProfitPublicApi < PennyProfitApiBase
    configure do
      set :public_folder, 'public'
      load_config routes: [:public]
    end
  end

  class PennyProfitSecureApi < PennyProfitApiBase

    configure do
      #Authenticate requests here

      load_config routes: [:secure]
    end

  end

  class PennyProfitAuthApi < PennyProfitApiBase
    configure do
      load_config routes: [:auth]
    end
  end
end

