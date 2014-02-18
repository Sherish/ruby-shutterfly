module RubyShutterfly
  class Go2ue

    def self.get_link(target, resource, user_id)
      if resource.kind_of? Array
        warn('No support for multiple resources yet')
        return nil
      else
        endpoint = "#{Endpoint::GO2UE}"
        timestamp = RubyShutterfly.timestamp
        sign = RubyShutterfly.generate_signature(endpoint, "oflyUserid=#{user_id}&resourceHref=#{resource}&target=#{target}", timestamp)
        params = "oflyAppId=#{RubyShutterfly.get_app_id}&oflyUserid=#{user_id}&target=#{target}&resourceHref=#{CGI::escape resource}&oflyHashMeth=#{RubyShutterfly.get_hash_method}&oflyTimestamp=#{CGI::escape timestamp}&oflyApiSig=#{sign}"
        url = "#{Endpoint::GO2UE_ROOT}#{Endpoint::GO2UE}?#{params}"
      end
    end

  end
end