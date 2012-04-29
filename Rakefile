task :default => [:run]

task :run  do
  ruby "lib/crowdsourced.rb"
end

task :test do
  exec "rspec spec -c --format nested"
end

task :run_cassandra do
  exec "cassandra -f"
end

task :setup_casandra do
  exec "cassandra-cli -h localhost < ./store/store.rb"
end
