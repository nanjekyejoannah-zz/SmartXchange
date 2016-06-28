CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAJ42FOFV26EZ7NAKA',
    :aws_secret_access_key  => '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',
    :region                 => 'eu-west-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'site_images'  # required
  config.fog_public     = true     # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
