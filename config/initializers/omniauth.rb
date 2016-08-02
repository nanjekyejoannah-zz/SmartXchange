# ENV['LINKEDIN_KEY'] = '7702ftprwock9u'
# ENV['LINKEDIN_SECRET'] = 'NOJrRm5zHSWL5dEQ'

Rails.application.config.middleware.use OmniAuth::Builder do
  # only have these at the moment (need partnership to get access to more with linkedin ): 'r_basicprofile r_emailaddress', by default, picturl-url is small image so including other option only which has bigger picture, positions and specialties showing up as null for e
  provider :linkedin, '7702ftprwock9u', 'NOJrRm5zHSWL5dEQ', :fields => ['id', 'email-address', 'first-name', 'last-name', 'headline', 'location', 'industry', 'summary', 'specialties', 'positions', 'picture-urls::(original)', 'public-profile-url']
end
