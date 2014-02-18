module RubyShutterfly
  class Album

    def initialize(user_id)
      @user_id = user_id
      @albums = []
    end

    def entries
      get unless @albums.any?
      @albums
    end

    def find_by_id(id)
      get unless @albums.any?
      @albums.select {|a| a.id == id}.first
    end

    def find_by_title(title)
      get unless @albums.any?
      @albums.select {|a| a.title == title}.first
    end

    def create(title)
      album = new(title)
      get
      album
    end

    private

    def get
      @albums = []
      endpoint = "#{Endpoint::ALBUM}/#{@user_id}"
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
        id = entry.xpath('id').first.text.split('/').last
        @albums << AlbumModel.new(@user_id, id, title)
      end
    end

    def new(title)
      endpoint = "#{Endpoint::ALBUM}/#{@user_id}/album"
      params = "oflyAppId=#{RubyShutterfly.get_app_id}&oflyUserid=#{@user_id}"
      timestamp = RubyShutterfly.timestamp
      response = RestClient.post("#{Endpoint::ALBUM_ROOT}#{endpoint}?#{params}", album_xml(title),
                                {
                                  'oflyHashMeth' => RubyShutterfly.get_hash_method,
                                  'oflyApiSig' => RubyShutterfly.generate_signature(endpoint, "oflyUserid=#{@user_id}", timestamp),
                                  'oflyTimestamp' => timestamp,
                                  'Content-Type' => 'text/xml'
                                })
      content = Nokogiri::XML.parse response.to_str
      content.remove_namespaces!
      title = content.xpath('//title').first.text
      id = content.xpath('//id').first.text.split('/').last
      AlbumModel.new(@user_id, id, title)
    end

    def album_xml(title)
      "<entry xmlns=\"http://www.w3.org/2005/Atom\" >
        <category term=\"album\" scheme=\"http://openfly.shutterfly.com/v1.0\" />
        <title>#{title}</title>
      </entry>"
    end
  end
end