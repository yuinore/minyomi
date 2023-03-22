minyomi

# Install

```
git checkout <<branch>>
cp .env{.sample,}
vi .env
bundle install
bundle exec rails db:create db:migrate db:seed
```

# Start Server

```
bundle exec rails s
```
