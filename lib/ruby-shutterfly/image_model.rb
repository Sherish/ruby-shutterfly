module RubyShutterfly
  class ImageModel
    attr_accessor :user_id, :id, :title, :summary, :published, :media, :link

    def initialize(user_id, id, title, summary, published, link, media)
      @user_id = user_id
      @id = id
      @title = title
      @summary = summary
      @publisehd = published
      @media = media
      @link = link
    end

    def go2ue(target)
      Go2ue.get_link(target, @link, @user_id)
    end
  end
end