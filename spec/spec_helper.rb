$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'rack'
require 'x-real-ip'

SUPPORT = File.join(File.dirname(__FILE__), "support")
Dir["#{SUPPORT}/*.rb"].each { |f| require f }

RSpec.configure do |config|

end
