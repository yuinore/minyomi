# minyomi

## DEMO

http://minyomi.org/

## Screenshot

<img width="931" alt="website_minyomi_00" src="https://user-images.githubusercontent.com/7114709/231462313-2030a088-0d77-4fcd-b80a-31ec4c90b2cc.png">

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
