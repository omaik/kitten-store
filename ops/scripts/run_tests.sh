# wait for DB start
sleep 10

bundle exec rake db:create db:schema:load
bundle exec rspec
