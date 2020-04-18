source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'rails', '>= 6.0.2.2'
gem 'bcrypt'
gem 'bootstrap-sass'
gem 'puma', '~> 3.11'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails', '~> 4.3'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'faker'         # 文字列生成
gem 'will_paginate'
gem 'bootstrap-will_paginate'

# バージョンが合わないとうまくいかない
gem 'carrierwave',             '1.1.0'   # 画像アップローダー
gem 'mini_magick',             '4.7.0'   # 画像をリサイズ
gem 'fog',                     '1.40.0'  # 本番環境で画像をアップロード

gem 'rails-i18n'    # エラーの日本語化
gem 'rename'    # アプリ名変更

group :development, :test do
  gem 'sqlite3', '~> 1.4'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rails-controller-testing', '~> 1.0.2'
  gem 'minitest-reporters',       '~> 1.1.14'
  gem 'guard',                    '~> 2.13.0'
  gem 'guard-minitest',           '~> 2.4.4'
end

group :production do
  gem 'pg', '~> 0.20.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'therubyracer'
