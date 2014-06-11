$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bundler/setup'
Bundler.require(:development)

require 'coveralls'
Coveralls.wear! unless ENV['SIMPLE_COVERAGE']

begin
  if ENV['SIMPLE_COVERAGE']
    require 'simplecov'
    SimpleCov.start do
      add_group 'Lib', 'lib'

      add_filter '/spec/'
    end
  end
rescue LoadError
  warn '=' * 80
  warn 'simplecov not installed. No coverage report'
  warn '=' * 80
end

#########################################
require 'sshkit/custom/dsl'
#########################################

Dir[File.join(File.expand_path(__dir__), 'support/**/*.rb')].each { |f| require f }

# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
