require 'spec_helper'

describe XRealIp do
  before :each do
    app = lambda { |env| @env = env; [ 200, {}, [] ] }
    @req = Rack::MockRequest.new(XRealIp::Middleware.new(app))
  end

  context 'no proxy' do
    context 'local ip' do
      context 'http' do
        before :each do
          env = {
            "REMOTE_ADDR" => "127.0.0.1",
          }
          @resp = @req.get("http://example.com/", env)
        end
        it 'sets ip' do
          @env["REMOTE_ADDR"].should eq '127.0.0.1'
        end
        it 'sets proxy ip' do
          @env["x.proxies"].should be_nil
        end
        it 'keeps http' do
          @env["rack.url_scheme"].should eq 'http'
        end
      end
      context 'https' do
        before :each do
          env = {
            "HTTP_X_FORWARDED_PROTO" => "https",
            "REMOTE_ADDR" => "127.0.0.1",
          }
          @resp = @req.get("http://test.com/", env)
        end
        it 'sets ip' do
          @env["REMOTE_ADDR"].should eq '127.0.0.1'
        end
        it 'sets proxy ip' do
          @env["x.proxies"].should be_nil
        end
        it 'keeps http' do
          @env["rack.url_scheme"].should eq 'http'
        end
      end
    end
  end

  context 'one proxy' do
    context 'local ip' do
      context 'http' do
        before :each do
          env = {
            "HTTP_X_REAL_IP" => "1.1.1.1",
            "REMOTE_ADDR" => "127.0.0.1",
          }
          @resp = @req.get("http://test.com/", env)
        end
        it 'sets ip' do
          @env["REMOTE_ADDR"].should eq '1.1.1.1'
        end
        it 'sets proxy ip' do
          @env["x.proxies"].should eq '127.0.0.1'
        end
        it 'keeps http' do
          @env["rack.url_scheme"].should eq 'http'
        end
      end
      context 'https' do
        before :each do
          env = {
            "HTTP_X_REAL_IP" => "1.1.1.1",
            "HTTP_X_FORWARDED_PROTO" => "https",
            "REMOTE_ADDR" => "127.0.0.1",
          }
          @resp = @req.get("http://test.com/", env)
        end
        it 'sets ip' do
          @env["REMOTE_ADDR"].should eq '1.1.1.1'
        end
        it 'sets proxy ip' do
          @env["x.proxies"].should eq '127.0.0.1'
        end
        it 'sets url scheme to https' do
          @env["rack.url_scheme"].should eq 'https'
        end
      end
    end
  end

  context '2 proxies' do
    context 'http' do
      before :each do
        env = {
          "HTTP_X_REAL_IP" => "1.1.1.1,10.0.0.1",
          "REMOTE_ADDR" => "127.0.0.1",
        }
        @resp = @req.get("http://test.com/", env)
      end
      it 'sets ip' do
        @env["REMOTE_ADDR"].should eq '1.1.1.1'
      end
      it 'sets proxy ip' do
        @env["x.proxies"].should eq '127.0.0.1,10.0.0.1'
      end
      it 'keeps http' do
        @env["rack.url_scheme"].should eq 'http'
      end
    end
    context 'https' do
      before :each do
        env = {
          "HTTP_X_REAL_IP" => "1.1.1.1,10.0.0.1",
          "HTTP_X_FORWARDED_PROTO" => "https",
          "REMOTE_ADDR" => "127.0.0.1",
        }
        @resp = @req.get("http://test.com/", env)
      end
      it 'sets ip' do
        @env["REMOTE_ADDR"].should eq '1.1.1.1'
      end
      it 'sets proxy ip' do
        @env["x.proxies"].should eq '127.0.0.1,10.0.0.1'
      end
      it 'sets url scheme to https' do
        @env["rack.url_scheme"].should eq 'https'
      end
    end
  end

  context 'spoofed' do
    context 'one' do
      before :each do
        env = {
          "HTTP_X_REAL_IP" => "1.1.1.1,2.2.2.2",
          "REMOTE_ADDR" => "3.3.3.3",
        }
        @resp = @req.get("http://test.com/", env)
      end
      it 'sets ip' do
        @env["REMOTE_ADDR"].should eq '3.3.3.3'
      end
      it 'doesnt st proxy ip' do
        @env["x.proxies"].should eq ''
      end
    end
    context 'chain' do
      before :each do
        env = {
          "HTTP_X_REAL_IP" => "1.1.1.1,2.2.2.2",
          "REMOTE_ADDR" => "127.0.0.1",
        }
        @resp = @req.get("http://test.com/", env)
      end
      it 'sets ip' do
        @env["REMOTE_ADDR"].should eq '2.2.2.2'
      end
      it 'sets proxy ip' do
        @env["x.proxies"].should eq '127.0.0.1'
      end
      it 'keeps http' do
        @env["rack.url_scheme"].should eq 'http'
      end
    end
  end

end
