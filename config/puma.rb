threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
threads threads_count, threads_count

preload_app!

app_dir = File.expand_path('../..', __FILE__)

# Run on unix socket only
# port ENV.fetch('PORT') { 3000 }

environment ENV.fetch('RAILS_ENV') { 'development' }

bind "unix://#{app_dir}/tmp/sockets/puma.sock"
pidfile "#{app_dir}/tmp/pids/puma.pid"
state_path "#{app_dir}/tmp/pids/puma.state"
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

activate_control_app

on_worker_boot do
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection
end
