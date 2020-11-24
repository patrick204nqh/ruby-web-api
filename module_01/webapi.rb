require 'sinatra'
require 'json'
require 'gyoku'

users = {
 'patrick': { first_name: 'Patrick', last_name: 'Robert', age: '20' },
 'kevin': {first_name: 'Kevin', last_name: 'De Bruyne', age: '29' }
}

helpers do
  def json_or_default?(type)
    ['application/json','application/*', '*/*'].include?(type.to_s)
  end

  def xml?(type)
    type.to_s == 'application/xml'
  end

  def accepted_media_type
    return 'json' unless request.accept.any?

    request.accept.each do |mt|
      return 'json' if json_or_default?(mt)
      return 'xml' if xml?(mt)
    end

    halt 406, 'Not Acceptable'
  end
end

get '/' do
  'Karl Patrick'
end

get '/users' do
  type = accepted_media_type

  if type == 'json'
    content_type 'application/json'
    users.map { |name, data| data.merge(id: name) }.to_json
  elsif type == 'xml'
    content_type 'application/xml'
    Gyoku.xml(users: users)
  end
end

get '/users/:first_name' do |first_name|
  type = accepted_media_type

  if type == 'json'
    content_type 'application/json'
    users[first_name.to_sym].merge(id: first_name).to_json
  elsif type == 'xml'
    content_type 'application/xml'
    Gyoku.xml(first_name => users[first_name.to_sym])
  end
end

head '/users' do
  type = accepted_media_type

  if type == 'json'
    content_type 'application/json'
  elsif type == 'xml'
    content_type 'application/xml'
  end
end

post '/users' do
  user = JSON.parse(request.body.read)
  users[user['first_name'].downcase.to_sym] = user

  url = "http://localhost:4567/users/#{user['first_name']}"
  response.headers['Location'] = url

  status 201
end

put '/users/:first_name' do |first_name|
  user = JSON.parse(request.body.read)
  existing = users[first_name.to_sym]
  users[first_name.to_sym] = user
  status existing ? 204 : 201
end

patch '/users/:first_name' do |first_name|
  type = accepted_media_type

  user_client = JSON.parse(request.body.read)
  user_server = users[first_name.to_sym]

  user_client.each do |key, value|
    user_server[key.to_sym] = value
  end

  if type == 'json'
    content_type 'application/json'
    user_server.merge(id: first_name).to_json
  elsif type == 'xml'
    content_type 'application/xml'
    Gyoku.xml(first_name => user_server)
  end
end

delete '/users/:first_name' do |first_name|
  users.delete(first_name.to_sym)
  status 204
end
