# VSCodeでrails環境を作る

## 前提条件
- 以下の基礎知識があること。
  - Docker
  - Docker Compose
  - Remote Containers(VSCode拡張)
  - Ruby on Rails
- 以下がインストール済であること。
  - Docker Desktop
  - VSCode
  - Remote Containers(VSCode拡張)

## ファイルを書き換える
- ミドルウェア、ライブラリ、フレームワークのバージョンを変更
  - .devcontainer/docker-compose.yml
    postgres
  - docker/app/Dockerfile
    - node
    - yarn
    - ruby
    - bundler
  - web/Dockerfile
    nginx
  - Gemfile
    rails
- アプリ名の変更
  Containerを作るために必要なファイルを用途に合わせて書き換える。「myapp」と記載された箇所は、作りたいrailsアプリ名に変更すること。

## Containerを作る
railsアプリの開発環境であるContainerを作る。
VSCodeでアプリのルートディレクトリをContainerにアタッチすることで、WindowsとContainerの双方でファイル操作が可能になる。アタッチ時にContainerが存在しなければ、VSCodeがDocker Composeで自動作成する。
1. VSCode画面左下の「リモートウィンドウを開く」をクリックする。
2. 「Remote-Containers: Reopen in Container」をクリックする。

## railsアプリを作る
```
rails new . --database=postgresql
```
既存ファイルの上書きについて、以下のようなメッセージが表示される。
```
Overwrite /myapp/README.md? (enter "h" for help) [Ynaqdhm]
```
「.gitignore」以外「Y」で。

## Gemfileを編集する
### 開発用gemを追加する
group :developmentに以下を追加する。
```
# For debugging
gem "debase"
gem "ruby-debug-ide"
# To clean code
gem "htmlbeautifier"
gem "rubocop", require: false
gem "rubocop-performance", require: false
gem "rubocop-rails", require: false
gem "solargraph"
```
**bundle installを忘れずに**

## DBを作る
railsには、config/database.ymlの内容でDBを作成するコマンドがある。それを実行する。
1. database.ymlを編集する。username, password, host, portを書き換える。
2. 以下コマンドを実行する。
```
rails db:create
```

## 開発時もnginxを使う
config/puma.rbの以下をコメントにする。
```
port        ENV.fetch("PORT") { 3000 }
```
config/puma.rbに以下を追加する。
```
bind "unix://#{Rails.root}/tmp/sockets/puma.sock"
```
