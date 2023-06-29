# sinatra


1. 作成したディレクトリでクローンを行う
```ruby
$ git clone https://github.com/massanengineer/sinatra.git
or
git clone -b sinatra-db https://github.com/massanengineer/sinatra.git
```

2. gemをインストールする
```
$ bundle install
```

3. memoデータベース&memosテーブル作成
```
psql
CREATE DATABASE memo;

\c memo

CREATE TABLE memos (
  id SERIAL,
  title VARCHAR(100) NOT NULL,
  content VARCHAR(1000) NOT NULL,
  PRIMARY KEY (id)
);

```

4. app.rb内の以下の`user:` `password` を任意の文字、数にする
```ruby
PG.connect(host: 'localhost', dbname: 'memo', user: '任意のユーザー', password: '任意のパスワード')
```


5. コマンドを実行する
```ruby
$ ruby app.rb
or
$ bundle exec ruby app.rb
```

6. http://localhost:4567 にアクセスする
