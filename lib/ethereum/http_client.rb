require 'net/http'
module Ethereum
  class HttpClient < Client
    attr_accessor :host, :port, :uri, :ssl, :user, :password

    def initialize(host, log = false)
      super(log)
      uri = URI.parse(host)
      raise ArgumentError unless ['http', 'https'].include? uri.scheme
      @host = uri.host
      @port = uri.port
      @user = uri.user
      @password = uri.password
      
      @ssl = uri.scheme == 'https'
      if ssl
        @uri = URI("https://#{@host}:#{@port}")
      else
        @uri = URI("http://#{@host}:#{@port}")
      end
    end

    def send_single(payload)
      http = ::Net::HTTP.new(@host, @port)
      if @ssl
        http.use_ssl = true
      end
      header = {'Content-Type' => 'application/json'}
      request = ::Net::HTTP::Post.new(uri, header)
      request.basic_auth @user, @password if @user && @password
      request.body = payload

      response = http.request(request)
      return response.body
    end

    def send_batch(batch)
      raise NotImplementedError
    end
  end

end
