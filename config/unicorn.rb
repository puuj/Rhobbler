worker_processes 2
preload_app false
timeout 30
listen "/home/rhobbler2/shared/sockets/rhobbler2.sock", :backlog => 64
pid "/home/rhobbler2/shared/unicorn.pid"
stderr_path "/home/rhobblerw/shared/log/unicorn.log"
stdout_path "/home/rhobbler2/shared/log/unicorn.log"
