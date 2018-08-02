require 'sinatra'

get '/' do
    'Hello NSSpain 2018 - you can access the API at /presets'
end

get '/presets' do
    File.read(File.join('public', 'presets.json'))
end
