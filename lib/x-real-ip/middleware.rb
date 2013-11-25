module XRealIp
  class Middleware
    def initialize(app)
      @app = app
    end

    def is_trusted?(str)
      ip = IPAddr.new(str)
      if ip.ipv4?
        XRealIp.trusted4.include?(ip.to_s)
      else
        XRealIp.trusted6.include?(ip.to_s)
      end
    end
    
    def call(env)
      real_ips  = env["HTTP_X_REAL_IP"]
      if real_ips
        begin
          proxies = []
          list = real_ips.split(',')
          return @app.call(env) if list.empty?
          list.push env["REMOTE_ADDR"]
          while tmp = list.pop
            addr = tmp
            if is_trusted?(tmp)
              proxies.push tmp
            else
              break
            end
          end
          
          if addr
            env["x.proxies"] = proxies.join(',')
            env["REMOTE_ADDR"] = addr
            proto = env["HTTP_X_FORWARDED_PROTO"] || env['HTTP_X_REAL_PROTO']
            if (proto && proto == 'https')
              env["rack.url_scheme"] = 'https'
            end
          end

          @app.call(env)
        rescue => e
          $stderr.puts "Error in x-real-ip: #{$!}"
          $stderr.puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
          @app.call(env)
        end
      else
        @app.call(env)
      end
    end
  end
end