# frozen_string_literal: true

# cf.
#   https://www.autovice.jp/articles/146
#   https://31webcreation.hatenablog.com/entry/2016/03/17/232427
#   https://loumo.jp/archives/21103

# ex: '/var/deploy/repository'
rails_root = File.expand_path('../', File.dirname(__FILE__))

# Unicorn Preferences
worker_processes  2
timeout           60
working_directory rails_root
pid               File.expand_path('tmp/pids/unicorn.pid', rails_root)
listen            File.expand_path('tmp/sockets/.unicorn.sock', rails_root)
stdout_path       File.expand_path('log/unicorn.log', rails_root)
stderr_path       File.expand_path('log/unicorn.log', rails_root)
preload_app       true

before_exec do |_server|
  ENV['BUNDLE_GEMFILE'] = "#{rails_root}/Gemfile"
end

before_fork do |server, _worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      Process.kill 'QUIT', File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
