# RubyShutterfly

This is a gem for the Shutterfly API. It is in the early stage, so it has method only for authentication, getting/creating albums and photos, and Go to Shutterfly User Experience API.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-shutterfly'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-shutterfly

## Usage

First, you have to configure RubyShutterfly with your's Application Id, Shared secret and callback url for authentication:

    RubyShutterfly.configure('your_app_id', 'your_shared_secret', 'http://localhost:3000/ruby-shutterfly')

Next, you need to get an authentication ulr and redirect user to it:

    RubyShutterfly.get_authentication_url

In your callback method grab the `oflyUserid` from params and store it elsewhere.

    user_id = params['oflyUserid']

Your main entry point is the Client class:

    client = RubyShutterfly::Client.new(user_id)

### Albums

To access user albums call the `albums` method:

    albums = client.albums

To get all albums call `entries` method:

    album_entries = albums.entries

To find specific album by it's id or title:

    album = albums.find_by_id('album_id')
    album = albums.find_by_title('album_title')

To create new album:

    album = albums.create('Album title')

### Images

To access album images call `images` method on album entry:

    images = album_entries.first.images

To get all album images call `entries` method:

    image_entries = images.entries

To upload new image pass the image file to the `create` method:

    image = images.create(image_file)

To get image url call the `link` method:

    url = image.link

Different image sizes available. To obtain them call the `media` method:

    media = image.media

You can call `height`, `width`, `type` and `url` methods on media object


### Go To Shutterfly UE

You can call a `go2ue` method on album entry, image entry and media objects. Just pass it the target (list of targets available here: http://www.shutterfly.com/documentation/go2ue.sfly ):

    album_entries.first.go2ue('OP')
    image_entries.first.go2ue('OP')
    image_entries.first.media.first.go2ue('OP')



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
