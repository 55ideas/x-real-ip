require "x-real-ip/version"
require "ipaddr"
# todo rails 4.2
#require 'action_dispatch/middleware/remote_ip'
require "active_support/core_ext/module/attribute_accessors"

module XRealIp
  mattr_accessor :trusted
  # todo rails 4.2
  #self.trusted = ActionDispatch::RemoteIp::TRUSTED_PROXIES
  self.trusted = [
      "127.0.0.1",      # localhost IPv4
      "::1",            # localhost IPv6
      "fc00::/7",       # private IPv6 range fc00::/7
      "10.0.0.0/8",     # private IPv4 range 10.x.x.x
      "172.16.0.0/12",  # private IPv4 range 172.16.0.0 .. 172.31.255.255
      "192.168.0.0/16", # private IPv4 range 192.168.x.x
  ].map { |proxy| IPAddr.new(proxy) }
end

require "x-real-ip/railtie" if defined? Rails

require "x-real-ip/middleware"