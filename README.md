# minyomi

## Install

```shell
git checkout <branch>
cp .env{.sample,}
vi .env
bundle install
bundle exec rails db:create db:migrate
```

db:seed is not necessary

## Start Server

```shell
bundle exec rails s
```

## Deploy

```shell
git checkout <branch>
cp .env{.sample,}
vi .env
RAILS_ENV=production bundle install

rm config/master.key
rm config/credentials.yml.enc
RAILS_ENV=production EDITOR="vim" bundle exec rails credentials:edit
RAILS_ENV=production bundle exec rails assets:precompile

# server test
RAILS_ENV=production bundle exec rails s
```
