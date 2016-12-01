require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/heroku_keepalive"

Lita::Handlers::HerokuKeepalive.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
