module PennyProfit
  class PennyProfitPublicApi < PennyProfitApiBase
    get '/' do
      send_file File.expand_path('index.html', "public"), :type => 'text/html'
    end

    get '/crossdomain.xml' do
      xml=<<EOL
<?xml version="1.0"?>
<!-- http://www.osmf.org/crossdomain.xml -->
<!DOCTYPE cross-domain-policy SYSTEM "http://www.adobe.com/xml/dtds/cross-domain-policy.dtd">
<cross-domain-policy>
    <allow-access-from domain="*" />
    <site-control permitted-cross-domain-policies="all"/>
</cross-domain-policy>
EOL

      halt(200, {'Content-type' => 'application/xml'}, [xml])

    end

  end
end

