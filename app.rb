# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

FILE_PATH = 'public/memos.json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def get_memos(file_path)
  File.open(file_path) do |file|
    JSON.parse(file.read)
  end
end

def set_memos(_file_path, memos)
  File.open(FILE_PATH, 'w') do |file|
    JSON.dump(memos, file)
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = get_memos(FILE_PATH)
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  memos = get_memos(FILE_PATH)
  @title = memos[params[:id]]['title']
  @content = memos[params[:id]]['content']
  erb :show
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  memos = get_memos(FILE_PATH)
  id = SecureRandom.uuid
  memos[id] = { 'title' => title, 'content' => content }
  set_memos(FILE_PATH, memos)
  redirect '/memos'
end

get '/memos/:id/edit' do
  memos = get_memos(FILE_PATH)
  @title = memos[params[:id]]['title']
  @content = memos[params[:id]]['content']
  erb :edit
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]
  memos = get_memos(FILE_PATH)
  memos[params[:id]] = { 'title' => title, 'content' => content }
  set_memos(FILE_PATH, memos)
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos = get_memos(FILE_PATH)
  memos.delete(params[:id])
  set_memos(FILE_PATH, memos)
  redirect '/memos'
end
