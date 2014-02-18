module RubyShutterfly
  class Client

    def initialize(user_id)
      @user_id = user_id
      @albums = Album.new(@user_id)
    end

    def albums
      @albums
    end

  end
end