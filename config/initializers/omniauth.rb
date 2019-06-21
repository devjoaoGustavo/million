Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    Million.credentials.google[:client_id],
    Million.credentials.google[:client_secret],
    skip_jwt: true
end
