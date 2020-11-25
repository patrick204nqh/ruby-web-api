require 'sinatra'
require 'json'

users = {
  patrick: { first_name: 'Patrick', last_name: 'Robert', age: 20 },
  kevin: { first_name: 'Kevin', last_name: 'Hart', age: 25 }
}

v1_lambda = lambda { |name, data| data }
v2_lambda = lambda do |name, data|
  { full_name: "#{data[:first_name]} #{data[:last_name]}", age: data[:age] }
end

supported_media_types = {
    '*/*' => v1_lambda,
    'application/*' => v1_lambda,
    'application/vnd.awesomeapi+json' => v1_lambda,
    'application/vnd.awesomeapi.v1+json' => v1_lambda,
    'application/vnd.awesomeapi.v2+json' => v2_lambda
}

get '/users' do
  accepted = request.accept.first ? request.accept.first.to_s : '*/*'

  unless supported_media_types.keys.include?(accepted)
    content_type 'application/vnd.awesomeapi.error+json'
    msg = {
      supported_media_types: supported_media_types.keys.join(', ')
    }.to_json
    halt 406, msg
  end

  content_type accepted
  users.map(&supported_media_types[accepted]).to_json
end

