Rails.application.config.middleware.use OmniAuth::Builder do
  p "client_id,secret"
  p ENV.fetch('GOOGLE_CLIENT_ID')
  p ENV.fetch('GOOGLE_CLIENT_SECRET')

  provider :google_oauth2,
    ENV.fetch('GOOGLE_CLIENT_ID'),
    ENV.fetch('GOOGLE_CLIENT_SECRET')
end
