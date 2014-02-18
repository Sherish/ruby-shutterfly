module RubyShutterfly
  class Image

    def initialize(user_id, album_id, album_name)
      @user_id = user_id
      @album_id = album_id
      @album_name = album_name
      @images = []
    end

    def entries
      get if @images.empty?
      @images
    end

    def create(file)
      image = new(file)
      get
      image
    end

    private

    def get
      @images = []
      endpoint = "#{Endpoint::ALBUM}/#{@user_id}/albumid/#{@album_id}"
      params = "category-type=image&oflyAppId=#{RubyShutterfly.get_app_id}&oflyUserid=#{@user_id}"
      timestamp = RubyShutterfly.timestamp
      response = RestClient.get("#{Endpoint::ALBUM_ROOT}#{endpoint}?#{params}",
                                {
                                  'oflyHashMeth' => RubyShutterfly.get_hash_method,
                                  'oflyApiSig' => RubyShutterfly.generate_signature(endpoint, "category-type=image&oflyUserid=#{@user_id}", timestamp),
                                  'oflyTimestamp' => timestamp
                                })
      content = Nokogiri::XML.parse response.to_str
      content.remove_namespaces!
      content.xpath('//feed/entry').each do |entry|
        title = entry.xpath('title').first.text
        summary = entry.xpath('summary').first.text
        published = Time.parse(entry.xpath('published').first.text)
        id = entry.xpath('id').first.text.split('/').last
        link = entry.xpath('link').first['href']
        media = []
        entry.xpath('group').first.xpath('content').each do |me|
          media << Media.new(me['type'], me['height'], me['width'], me['url'], @user_id)
        end
        @images << ImageModel.new(@user_id, id, title, summary, published, link, media)
      end
    end

    def new(file)
      endpoint = "#{Endpoint::IMAGE}"
      params = "oflyAppId=#{RubyShutterfly.get_app_id}&oflyUserid=#{@user_id}"
      timestamp = RubyShutterfly.timestamp
      response = RestClient.post("#{Endpoint::IMAGE_ROOT}#{endpoint}?#{params}",
                                {
                                  'Image.AlbumName' => @album_name,
                                  'Image.Data' => file
                                },
                                {
                                  'oflyHashMeth' => RubyShutterfly.get_hash_method,
                                  'oflyApiSig' => RubyShutterfly.generate_signature(endpoint, "oflyUserid=#{@user_id}", timestamp),
                                  'oflyTimestamp' => timestamp
                                })
      content = Nokogiri::XML.parse response.to_str
      content.remove_namespaces!
      entry = content.xpath('//feed/entry').first
      title = entry.xpath('title').first.text
      summary = entry.xpath('summary').first.text
      published = Time.parse(entry.xpath('published').first.text)
      id = entry.xpath('id').first.text.split('/').last
      link = entry.xpath('link').first['href']
      media = []
      entry.xpath('group').first.xpath('content').each do |me|
        media << Media.new(me['type'], me['height'], me['width'], me['url'], @user_id)
      end
      ImageModel.new(@user_id, id, title, summary, published, link, media)
    end

  end
end