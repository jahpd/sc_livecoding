#!/home/guilherme/.rvm/rubies/ruby-2.1.2/bin/ruby
# -*- coding: utf-8 -*-

require 'sinatra'
require "#{File.dirname(__FILE__)}/lib/d3"
require "#{File.dirname(__FILE__)}/lib/script"
require "#{File.dirname(__FILE__)}/lib/searchs"
require "#{File.dirname(__FILE__)}/lib/nosuch/db"
require 'base64'
require 'securerandom'

include Client::Script
include D3
include Client::Nosuch::Database
include Client::Wordcloud

get "/" do
  @title = "Statistics "
  @list = ["soundcloud", "github", "nosuch"]
  erb :index
end

get "/:client" do
  @client = params[:client]
  @title = "Statistics for #{@client}"
  @list = Client::GithubSearch::SEARCHS if @client=="github"
  @list = Client::SoundcloudSearch::SEARCHS if @client=="soundcloud"
  @list = Client::NosuchSearch::SEARCHS if @client=="nosuch"
  
  erb :entrie
end

get "/:client/:entry" do
  @client = params[:client]
  @title = "Statistics for #{@client}"
  @list = [params[:entry]]
  @entries =  Client::GithubSearch::STATS if @client=="github"
  @entries =  Client::SoundcloudSearch::STATS if @client=="soundcloud"
  @entries = Client::NosuchSearch::SEARCHS if @client=="nosuch"

  unless @client == "nosuch"
    erb :entrie
  else
    @path = make_json(@client)
    erb :histogram
  end
end

get "/iclc/:quality" do
  html = """<html>
  <head>
    <title>wordcloud live coding</title>
  </head>
  <body>"""
  Client::Wordcloud::results()[params[:quality]].each do |words|
    html << "\n    <p>#{word}</p>\n"
  end
  html << "\n  </body>"
  html << "</html>"
  erb html
end

get "/:client/:entry/:sub" do
  @client = params[:client]
  @title = "Statistics for #{@client}"
  @entry = params[:entry]
  @sub = params[:sub]
  
  @list = @client == "github" ? Client::GithubSearch::STATS : Client::SoundcloudSearch::STATS
  @layouts =  ["streamgraph", "sunburst", "circle_packing", "zoomable_circle_packing"]

  erb :sub
end

get "/:client/:entry/:sub/:compare" do
 
  client = params[:client]
  entry = params[:entry]
  sub = params[:sub]
  compare = params[:compare]

  @title = "Statistics for #{entry}'s #{client} comparing tag <i>#{sub}</i> with <i>#{compare}</i>"
  
  # create a json file to load in client
  path = treemap_json client, entry, sub, compare

  # layouts have helpers
  puts "=> Loading script: #{params[:layout]}"
  if params[:layout]=="sunburst"
    puts "Ready!"
    @src = sunburst path
    @css = sunburst_css
  elsif params[:layout]=="streamgraph"
    puts "Ready!"
    @src = streamgraph path
    @css = streamgraph_css
  elsif params[:layout]=="circle_packing"
    puts "Ready!"
    @src = circle_packing path
    @css = circle_packing_css
  elsif params[:layout]=="zoomable_circle_packing"
    puts "Ready!"
    @src = zoomable_circle_packing path
    @css = zoomable_circle_packing_css
  end

  erb :d3
end

get '/stats/:file[.json]' do |file|
  file = File.join('./public/stats', file)
  send_file(file, :disposition => 'attachment', :filename => File.basename(file))
end

get '/scripts/:file[.js]' do |file|
  file = File.join('./public/scripts', file)
  send_file(file, :disposition => 'attachment', :filename => File.basename(file))
end

get '/images/:file[.png]' do |file|
  file = File.join('./public/images', file)
  send_file(file, :disposition => 'attachment', :filename => File.basename(file))
end
