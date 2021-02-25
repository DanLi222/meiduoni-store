module Paypal
  class PaypalAuthenticator
    def call
      get_latest_token
      return @token if is_valid?
      get_token
    end

    private 
    def get_token
      auth = {:username => ENV['PAYPAL_CLIENT_ID'], :password => ENV['PAYPAL_SECRET']}
      response = HTTParty.post("https://api.sandbox.paypal.com/v1/oauth2/token", 
              :basic_auth => auth,
              :body => {:grant_type => 'client_credentials'})
      if response.code == 200
          params = { access_token: response['access_token'], expires_at: Time.now + response['expires_in'] }
          @token = PaypalToken.create(params)
      else
          @token = nil
      end
      @token
    end

    def is_valid?
      @token && @token.expires_at > Time.now
    end

    def get_latest_token
      @token = PaypalToken.last
    end
  end
end
