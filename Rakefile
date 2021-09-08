require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'


if defined?(Knapsack) && ENV['CI_PARALLEL_TESTS'] == 'true'
  ENV['KNAPSACK_REPORT_PATH'] = 'reports/knapsack.json'
  Knapsack.load_tasks
end
