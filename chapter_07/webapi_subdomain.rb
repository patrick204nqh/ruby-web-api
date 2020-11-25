require 'sinatra'
require 'sinatra/subdomain'
require 'json'

users = {
  patrick: {first_name: 'Patrick', last_name: 'Robert', age: 20 },
  kevin: {first_name: 'Kevin', last_name: 'Hart', age: 25 } 
}

before do
  content_type 'application/json'
end

# This is the routes for v1
subdomain :api1 do 
  get '/users' do 
    users.map do { |name, data| data }
  end
end

# And this block contains the routes for v2
subdomain :api2 do
  get '/users' do
    users.map do |name, data|
      {
        full_name: "#{data[:first_name]} #{data[:last_name]}",
        age: data[:age]
      }
    end.to_json
  end
end



