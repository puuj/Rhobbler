Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
