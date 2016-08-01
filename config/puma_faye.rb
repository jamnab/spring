#!/usr/bin/env puma

directory '/home/deploy/launchboard/current'
rackup "/home/deploy/launchboard/current/sync.ru"
environment 'production'

pidfile "/home/deploy/launchboard/shared/tmp/pids/faye.pid"
state_path "/home/deploy/launchboard/shared/tmp/pids/faye.state"
stdout_redirect '/home/deploy/launchboard/shared/log/faye.error.log', '/home/deploy/launchboard/shared/log/faye.access.log', true


threads 1,2

bind 'tcp://localhost:9292/'

workers 2

preload_app!
