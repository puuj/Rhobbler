worker_processes 2
preload_app false
timeout 30
listen "/tmp/rhobbler.sock", :backlog => 64
pid "/home/rhobbler2/shared/unicorn.pid"
stderr_path "/sites/rhobbler/shared/log/unicorn.log"
stdout_path "/sites/rhobbler/shared/log/unicorn.log"
