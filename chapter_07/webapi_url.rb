require 'sinatra'
require 'sinatra/contrib'
require 'json'

users = {
  patrick: { first_name: 'Patrick', last_name: 'Robert', age: 20 },
  kevin: { first_name: 'Kevin', last_name: 'Hart', age: 25 },
}

before do
  content_type 'application/json'
end

namespace '/v1' do
  get '/users' do
    users.map { |name, data| data }.to_json
  end
end

namespace '/v2' do
  get '/users' do
    users.map do |name, data|
      {
        full_name: "#{data[:first_name]} #{data[:last_name]}",
        age: data[:age]
      }
    end.to_json
  end
end
