require 'sinatra'
require 'json'

users = {
  patrick: { first_name: 'Patrick', last_name: 'Robert', age: 20 },
  kevin: { first_name: 'Kevin', last_name: 'Hart', age: 25 }
}

helpers do
  def present_v2(data)
    {
      full_name: "#{data[:first_name]} #{data[:last_name]}",
      age: data[:age]
    }
  end
end

before do
  content_type 'application/json'
end

get '/users' do
  if request.env['HTTP_VERSION'] == '2.0'
    halt 200, users.map { |name, data| present_v2(data) }.to_json
  end
  users.map { |name, data| data }.to_json
end
