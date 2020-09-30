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
  - docker/Dockerfile
    - node
    - yarn
    - ruby
    - bundler
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
rails new . --database=postgresql --skip-sprockets --skip-test
```
既存ファイルの上書きについて、以下のようなメッセージが表示される。
```
Overwrite /myapp/README.md? (enter "h" for help) [Ynaqdhm]
```
「.gitignore」以外「Y」で。

## 開発用パッケージを追加する
### Gemfileを編集する
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
以下を
```
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
```
以下のように編集する
```
gem 'tzinfo-data'
```
**bundle installを忘れずに**

### package.jsonを編集する
devDependenciesに以下を追加する。
```
"eslint": "^6.8.0",
"eslint-config-prettier": "^6.11.0",
"eslint-plugin-prettier": "^3.1.3",
"prettier": "^2.0.5",
"stylelint": "^13.3.3",
"stylelint-config-prettier": "^8.0.1",
"stylelint-config-standard": "^20.0.0",
"stylelint-prettier": "^1.1.2",
"stylelint-scss": "^3.17.1",
```

## DBを作る
railsには、config/database.ymlの内容でDBを作成するコマンドがある。それを実行する。
1. database.ymlを編集する。username, password, host, portを書き換える。
2. 以下コマンドを実行する。
```
rails db:create
```

## credentials.yml.encとmaster.keyを削除する
productionへの配置が面倒なので、configからcredentials.yml.encとmaster.keyを削除し、secrets.ymlを配置する。
secrets.ymlの中身は以下の通り。
```
production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
```
**productionのSECRET_KEY_BASEは各クラウド環境で安全に管理すること。**

## RSpecの導入
group :testに以下を追加する。
```
gem "factory_bot_rails"
gem "rspec-rails"
```
https://github.com/takutoki/baukis2/tree/master/spec のrails_helper.rb、spec_helper.rbをコピペする。

### FactoryBotでエラーが出たら
rails_helper.rbに以下を追加する。
```
config.before(:all) do
  FactoryBot.reload
end
```

## [Asset PipelineからWebpackへ](https://techracho.bpsinc.jp/hachi8833/2017_12_26/49931)
全部Webpackerでやる
