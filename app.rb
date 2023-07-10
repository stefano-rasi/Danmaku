require 'opal'
require 'base64'
require 'sinatra'

get '/' do
    slim :game
end

get '/sequences/*' do
    @sequence = "/sequence/#{params[:splat][0]}"

    slim :game
end

get '/sequence/*' do
    path = "sequences/#{params[:splat][0]}"

    send_file path
end

get '/main' do
    content_type 'text/javascript'

    builder = Opal::Builder.new()

    builder.append_paths('.')
    builder.append_paths('lib')

    builder.build('main.rb')

    %Q{
        #{builder.to_s}
        #{builder.source_map.to_data_uri_comment}
    }
end