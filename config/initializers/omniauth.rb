Rails.application.config.middleware.use OmniAuth::Builder do
  # only have these at the moment (need partnership to get access to more with linkedin ): 'r_basicprofile r_emailaddress', by default, picturl-url is small image so including other option only which has bigger picture, positions and specialties showing up as null for e
  provider :linkedin, ENV['LINKEDIN_API_KEY'], ENV['LINKEDIN_SECRET_KEY'], :fields => ['id', 'email-address', 'first-name', 'last-name', 'headline', 'location', 'industry', 'summary', 'specialties', 'positions', 'picture-urls::(original)', 'public-profile-url']
end
