module PennyProfit
  module ApiInitializer
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def run_initializer(options={}, &block)
        Sinatra::Base.environment = :test 

        # HACK: Silence the annoying warning
        I18n.enforce_available_locales = false

        # Disables csrf so the rest-service will work
        set :protection, :except => :http_origin

        # Enable cors
        register Sinatra::CrossOrigin
        enable :cross_origin

        require_routes

        block.call unless block.nil?
      end

      def require_routes(options = {})
         Dir[File.expand_path("../", "app") + "/api/routes/*/*"].reject { |p| File.directory? p }.each do |file|
          require file
        end
      end
    end
  end
end
