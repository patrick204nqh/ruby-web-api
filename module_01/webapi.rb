require 'sinatra'
require 'json'

users = {
 'patrick': { first_name: 'Patrick', last_name: 'Robert', age: '20' },
 'kevin': {first_name: 'Kevin', last_name: 'De Bruyne', age: '29' }
}

before do 
  content_type 'application/json'
end

get '/' do
  'Karl Patrick'
end

get '/users' do
  users.map { |name, data| data.merge(id: name) }.to_json
end
