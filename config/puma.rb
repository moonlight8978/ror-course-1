workers ENV.fetch('RAILS_WEB_CONCURRENCY') { 2 }
threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
threads threads_count, threads_count

app_dir = File.expand_path('..', __dir__)

preload_app!

environment ENV.fetch('RAILS_ENV') { 'development' }
port ENV.fetch('RAILS_PORT') { 3000 }

on_worker_boot do
  require 'active_record'
  begin
    ActiveRecord::Base.connection.disconnect!
  rescue StandardError
    ActiveRecord::ConnectionNotEstablished
  end
  ActiveRecord::Base.establish_connection
end
