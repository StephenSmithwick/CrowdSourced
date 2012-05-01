task :default => [:run]

task :run  do
  ruby "lib/crowdsourced_playground.rb"
end

task :server do
  ruby "lib/crowdsourced.rb"
end

task :mongod do
  exec "mongod --config conf/mongod.conf"
end

task :test do
  exec "rspec spec -c --format nested"
end
