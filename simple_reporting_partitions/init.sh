
### 
### Hack to make sources available despite security messing up with SSL ...
###
sed -i 's/https/http/g' Gemfile
gem sources -r https://rubygems.org/
yes | gem sources --add http://rubygems.org

###
### Downloads missing gems for test & development
###
bundle config --delete without
bundle install
bundle remove flipper flipper-active_record flipper-ui
bundle add flipper flipper-active_record flipper-ui --version 1.3.4

###
### Turns on feature flags
###
bundle exec flipper enable :auto_approve_users

###
### Initialises the DB
###
bundle exec rake db:setup
psql -h postgres -p 5432 -U postgres -f db/structure.sql
