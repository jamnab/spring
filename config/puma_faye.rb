#!/usr/bin/env puma

directory '/home/deploy/launchboard'
rackup "/home/deploy/launchboard/sync.ru"
environment 'production'

pidfile "/home/deploy/launchboard/tmp/pids/faye.pid"
state_path "/home/deploy/launchboard/tmp/pids/faye.state"
stdout_redirect '/home/deploy/launchboard/log/faye.error.log', '/home/syncidlabs/inthought/log/faye.access.log', true


threads 1,2

bind 'tcp://localhost:9292/'

workers 2

preload_app!
