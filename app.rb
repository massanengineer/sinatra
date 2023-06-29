# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def connection
  @connection ||= PG.connect(host: 'localhost', dbname: 'memo', user: '任意のユーザー', password: '任意のパスワード')
end

def post(title, content)
  connection.exec_params('INSERT INTO memos (title, content) VALUES ($1, $2)', [title, content])
end

def find_memo(id)
  result = connection.exec('SELECT * FROM memos WHERE id = $1 LIMIT 1', [id])
  result.first
end

def fetch_all_memos
  connection.exec('SELECT * FROM memos ORDER BY id')
end

def update(title, content, id)
  connection.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, id])
end

def delete(id)
  connection.exec_params('DELETE FROM memos WHERE id = $1', [id])
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = fetch_all_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  memo = find_memo(params[:id])
  @title = memo['title']
  @content = memo['content']
  erb :show
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  post(title, content)
  redirect '/memos'
end

get '/memos/:id/edit' do
  memo = find_memo(params[:id])
  @title = memo['title']
  @content = memo['content']
  erb :edit
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]
  update(title, content, params[:id])
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  delete(params[:id])
  redirect '/memos'
end
