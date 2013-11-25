require "x-real-ip/version"
require "rpatricia"
require "ipaddr"
require "active_support/core_ext/module/attribute_accessors"

module XRealIp
  mattr_accessor :trusted4, :trusted6
  self.trusted4 = Patricia.new()
  %w(10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 127.0.0.0/8).each do |a|
    self.trusted4.add(a)
  end
  self.trusted6 = Patricia.new(:AF_INET6)
  %w(::1/128).each do |a|
    self.trusted6.add(a)
  end
end

require "x-real-ip/railtie" if defined? Rails

require "x-real-ip/middleware"