require 'sinatra'

use Rack::Auth::Basic, 'User Area' do |username, password|
  username == 'json' && password == 'pass'
end

get '/' do
  'Karl Patrick'
end
