module RubyShutterfly
  class AlbumModel

    attr_accessor :user_id, :id, :title

    def initialize(user_id, id, title)
      @user_id = user_id
      @id = id
      @title = title
      @images = Image.new(user_id, id, title)
    end

    def images
      @images
    end

    def go2ue(target)
      Go2ue.get_link(target, "#{Endpoint::ALBUM_ROOT}#{Endpoint::ALBUM}/userid/#{@user_id}/albumid/#{@id}", @user_id)
    end

  end
end