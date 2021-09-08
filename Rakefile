require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

if ENV['CI_PARALLEL_TESTS'] == 'true'
  require 'knapsack'
  ENV['KNAPSACK_REPORT_PATH'] = 'reports/knapsack.json'
  Knapsack.load_tasks
end
