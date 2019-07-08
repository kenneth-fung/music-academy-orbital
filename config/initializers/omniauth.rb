Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, 
    Rails.application.credentials[Rails.env.to_sym][:GOOGLE_CLIENT_ID],
    Rails.application.credentials[Rails.env.to_sym][:GOOGLE_CLIENT_SECRET]
end
