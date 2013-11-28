module XRealIp
  class Railtie < Rails::Railtie
    initializer "railtie.configure_rails_initialization" do |app|
      app.config.middleware.insert_before Rack::Runtime, XRealIp::Middleware
    end
  end
end
