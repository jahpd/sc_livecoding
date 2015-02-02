# -*- coding: utf-8 -*-
require 'sinatra'
require "#{File.dirname(__FILE__)}/stat"
require "#{File.dirname(__FILE__)}/script"
require "#{File.dirname(__FILE__)}/searchs"
require 'base64'
require 'securerandom'
require 'rmagick'

get "/" do
  @title = "Statistics "
  @list = ["soundcloud", "github"]
  erb :index
end


get "/:client" do
  @client = params[:client]
  @title = "Statistics for #{@client}"
  @list = Client::GithubSearch::SEARCHS if @client=="github"
  @list = Client::SoundcloudSearch::SEARCHS if @client=="soundcloud"
  
  erb :entrie
end

get "/:client/:entry" do
  @client = params[:client]
  @title = "Statistics for #{@client}"
  @list = [params[:entry]]
  @entries =  Client::GithubSearch::STATS if @client=="github"
  @entries =  Client::SoundcloudSearch::STATS if @client=="soundcloud"

  erb :entrie
end

include Statistics::TSV
include Client::Script

get "/:client/:entry/:subentry" do 
  sb = params[:subentry]
  gen_for params[:entry], params[:subentry], :client => params[:client]
  @data_name = SecureRandom.hex()
  @src = create params[:entry], params[:subentry], :client => params[:client]
  erb :pie
end


post "/:client/:entry/:subentry/:png" do
  name = "#{params[:client]}_#{params[:entry]}_#{params[:subentry]}"
  images = "./public/images"
  png = "#{images}/#{name}.png"

  data = params[:png_data]
  datum = data['data:image/png;base64,'.length .. -1]
  puts datum
  bytes = Base64.decode64(datum)
  f = File.open(png, "wb")
  f.write bytes

  redirect "/images/#{name}.png"
end

get '/stats/:file' do |file|
  file = File.join('./public/stats', file)
  send_file(file, :disposition => 'attachment', :filename => File.basename(file))
end

get '/scripts/:file' do |file|
  file = File.join('./public/scripts', file)
  send_file(file, :disposition => 'attachment', :filename => File.basename(file))
end

get '/images/:file' do |file|
  file = File.join('./public/images', file)
  send_file(file, :disposition => 'attachment', :filename => File.basename(file))
end








