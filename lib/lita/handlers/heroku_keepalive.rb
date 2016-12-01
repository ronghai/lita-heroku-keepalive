module Lita
  module Handlers
    class HerokuKeepalive < Handler
      # insert handler code here

      Lita.register_handler(self)
    end
  end
end
