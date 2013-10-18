require 'sinatra'
require 'coffee-script'
require 'pry'
require_relative 'boottime.rb'

get '/' do
  erb :index
end

get '/app.js' do
  coffee :app
end

post '/parse' do
  script_info = process_audit(params[:post][:data])
  erb :results, :locals => {:data => script_info}
end