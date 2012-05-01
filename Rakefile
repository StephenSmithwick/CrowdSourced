task :default => [:run]

task :run  do
  ruby "lib/crowdsourced.rb"
end

task :test do
  exec "rspec spec -c --format nested"
end
