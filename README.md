# DEPRECATED

consider using X-Forwarded-For which is natively supported instead

# X-Real-IP

Replace REMOTE_IP with X-Real-Ip if it's trusted (useful for Nginx)

## Installation

Add this line to your application's Gemfile:

    gem 'x-real-ip'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install x-real-ip

## Usage

For rails just add it to Gemfile

For rack/sinatra

    use XRealIp::Middleware

Or in Rack::Builder like this:

    app = Rack::Builder.new do
      use XRealIp::Middleware
      use Raven::Rack
      map '/serve' do
        run Serve.new
      end
      map '/' do
        run App.new
      end
    end

    run app

## Credits

Some ideas from https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/middleware/remote_ip.rb

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
