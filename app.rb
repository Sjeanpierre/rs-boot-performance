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
  script_info = BootTimer.new(params[:post][:data]).process
  erb :results, :locals => {:data => script_info}
end