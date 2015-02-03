Thread.new do
  system("rackup sync.ru -E #{ENV['RAILS_ENV']}")
  puts ENV['RAILS_ENV']
end
