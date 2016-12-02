require 'time'
module Lita
  module Handlers
    class HerokuKeepalive < Handler
      # insert handler code here
      WAKE_UP_TIME = (ENV["LITA_HEROKU_WAKEUP_TIME"] || "06:00").split(":").map(&:to_i)
      SLEEP_TIME = (ENV["LITA_HEROKU_SLEEP_TIME"] || "22:00").split(":").map(&:to_i)
      WALKE_UP_OFFSET = ( WAKE_UP_TIME[0] * 60 + WAKE_UP_TIME[1]) % 1440
      AWAKE_MINUTES =  ((SLEEP_TIME[0] + 24) * 60  + SLEEP_TIME[1] - WALKE_UP_OFFSET) % 1440
      
      KEEPALIVE_INTERVAL = (ENV["LITA_HEROKU_KEEPALIVE_INTERVAL"] || "5" ) .to_i * 60
      KEEPALIVE_URL = ENV["LITA_HEROKU_KEEPALIVE_URL"] || ENV["HEROKU_URL"]
      
      if KEEPALIVE_URL
      	unless KEEPALIVE_URL[-1] == '/'
          KEEPALIVE_URL = KEEPALIVE_URL + "/"
        end
        
        http.get "/heroku/keepalive" do |request, response|
          #log.info ">>>>>>>"
          response.body << "OK"
        end
        http.post "/heroku/keepalive" do |request, response|
          response.body << "OK"
        end

        on(:loaded) do
          log.info "staring ping keep alive url #{KEEPALIVE_URL}heroku/keepalive"
          every(KEEPALIVE_INTERVAL) do
            now = Time.now
            minutes = (60 * (now.hour + 24) + now.min - WALKE_UP_OFFSET) % (60 * 24)
            if minutes <= AWAKE_MINUTES
              log.info "Keepalive ping..."
              http.get "#{KEEPALIVE_URL}heroku/keepalive" 
            else
              log.info "skipping keep alive, time to rest"
            end
          end
        end
      else
        puts(" LITA_HEROKU_KEEPALIVE_URL is missing.\n`heroku config:set LITA_HEROKU_KEEPALIVE_URL=$(heroku apps:info -s  | grep web_url | cut -d= -f2)`")
      end
      
      
      Lita.register_handler(self)
    end
  end
end
