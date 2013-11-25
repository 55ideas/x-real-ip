module XRealIp
  class Railtie < Rails::Railtie
    initializer "railtie.configure_rails_initialization" do |app|
      app.config.middleware.use XRealIp::Middleware
    end
  end
end
