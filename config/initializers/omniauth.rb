# Settings in config/application.yml
if Settings.ldap
  ldap = Settings.ldap
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :ldap,
      :host => ldap.host,
      :port => ldap.port,
      :method => ldap.method,
      :base => ldap.base,
      :uid => ldap.uid
  end
end
