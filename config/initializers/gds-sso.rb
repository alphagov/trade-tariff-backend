GDS::SSO.config do |config|
  config.user_model   = "User"
  config.oauth_id     = ENV['TRADE_TARIFF_OAUTH_ID'] || "abcdefgh12345678pan"
  config.oauth_secret = ENV['TRADE_TARIFF_OAUTH_SECRET'] || "secret"
  config.oauth_root_url = Plek.current.find("signon")
end
