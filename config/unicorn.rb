worker_processes 2
preload_app false
timeout 30
listen "/tmp/rhobbler.sock", :backlog => 64
pid "/sites/rhobbler/tmp/pids/unicorn.pid"
stderr_path "/sites/rhobbler/log/unicorn.log"
stdout_path "/sites/rhobbler/log/unicorn.log"
