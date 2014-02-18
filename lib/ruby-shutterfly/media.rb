module RubyShutterfly
  class Media
    attr_accessor :type, :width, :height, :url

    def initialize(type, height, width, url, user_id)
      @type = type
      @height = height
      @width = width
      @url = url
      @user_id = user_id
    end

    def go2ue(target)
      Go2ue.get_link(target, url, @user_id)
    end
  end
end