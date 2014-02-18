module RubyShutterfly
  attr_accessor :app_id, :hash_method

  @app_id
  @app_secret
  @hash_method = 'SHA1'
  @callback_url

  def self.configure(application_id, shared_secret, callback_url)
    @app_id = application_id
    @app_secret = shared_secret
    @callback_url = callback_url
  end

  def self.get_app_id
    @app_id
  end

  def self.get_hash_method
    @hash_method
  end

end