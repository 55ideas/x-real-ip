module XRealIp
  class Middleware
    def initialize(app)
      @app = app
    end

    def is_trusted?(str)
      begin
        ip = IPAddr.new(str.strip)
      rescue Exception => e
        $stderr.puts "Error in x-real-ip parsing address '#{str.strip}': #{e.message}"
        $stderr.puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
        raise e
      end
      XRealIp.trusted.any? { |proxy| proxy === ip }
    end

    def call(env)
      real_ips  = env["HTTP_X_REAL_IP"]
      if real_ips
        # for Rails logger
        env["HTTP_X_FORWARDED_FOR"] = real_ips
      else
        real_ips  = env["HTTP_X_FORWARDED_FOR"]
      end
      if real_ips
        proxies = []
        list = real_ips.split(',')
        return @app.call(env) if list.empty?
        begin
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
        rescue => e
          $stderr.puts "Error in x-real-ip: #{e.message}"
          $stderr.puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
        end
      end
      @app.call(env)
    end
  end
end
