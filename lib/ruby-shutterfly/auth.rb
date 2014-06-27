module RubyShutterfly

  def self.get_authentication_url
    timestamp = self.timestamp
    params = "oflyAppId=#{@app_id}&oflyCallbackUrl=#{@callback_url}&oflyHashMeth=#{@hash_method}&oflyTimestamp=#{CGI::escape timestamp}"
    "#{Endpoint::LOGIN_ROOT}#{Endpoint::LOGIN}?#{params}&oflyApiSig=#{generate_signature(Endpoint::LOGIN, "oflyCallbackUrl=#{@callback_url}", timestamp)}"
  end

  def self.timestamp
    #Time.now.strftime('%Y-%m-%dT%H:%M:%S.%L%Z')
    Time.now.utc.strftime('%Y-%m-%dT%H:%M:%S.%L%:z')
  end

  def self.generate_signature(endpoint, params, timestamp)
    sign = @app_secret + endpoint + '?' + params + "&oflyAppId=#{@app_id}&oflyHashMeth=#{@hash_method}&oflyTimestamp=#{timestamp}"
    Digest::SHA1.hexdigest(sign)
  end

end
