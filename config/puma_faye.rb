#!/usr/bin/env puma

directory '/home/syncidlabs/inthought'
rackup "/home/syncidlabs/inthought/sync.ru"
environment 'production'

pidfile "/home/syncidlabs/inthought/tmp/pids/faye.pid"
state_path "/home/syncidlabs/inthought/tmp/pids/faye.state"
stdout_redirect '/home/syncidlabs/inthought/log/faye.error.log', '/home/syncidlabs/inthought/log/faye.access.log', true


threads 1,5

bind 'tcp://localhost:9292/'

workers 2

preload_app!
