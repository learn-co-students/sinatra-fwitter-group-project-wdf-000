require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

# 'config.raise_errors_for_deprecations!'





use Rack::MethodOverride
run ApplicationController
