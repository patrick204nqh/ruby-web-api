require File.expand_path '../webapi_digest_auth.rb', __FILE__

app = Rack::Auth::Digest::MD5.new(Sinatra::Application) do |username|
  { 'patrick' => 'pass' }[username]
end

app.realm = 'User Area'
app.opaque = 'secretkey'

run app
