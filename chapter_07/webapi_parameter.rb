require 'sinatra'
require 'sinatra/contrib'
require 'json'

users = {
  patrick: { first_name: 'Patrick', last_name: 'Robert', age: 20 }, 
  kevin: { first_name: 'Kevin', last_name: 'Hart', age: 25 }
}

before do 
  content_type 'application/json'
end

helpers do
  def present_300
    {
      message: 'Multiple Verssions Available (?version=)',
      links: {
        v1: '/users?version=v1',
        v2: '/users?version=v2'
      }
    }
  end

  def present_v2(data)
    {
      full_name: "#{data[:first_name]} #{data[:last_name]}",
      age: data[:age]
    }
  end
end

get '/users' do
  versions = {
    'v1' => lambda { |name, data| data },
    'v2' => lambda { |name, data| present_v2(data) }
  }

  unless params['version'] && versions.keys.include?(params['version'])
    halt 300, present_300.to_json
  end

  users.map(&versions[params['version']]).to_json
end
