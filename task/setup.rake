namespace :setup do
  begin
    require 'bundler'
  rescue LoadError
    print "Installing bundler..."
    sh 'gem install bundler --no-ri --no-rdoc'
    puts "done"
  ensure
    puts "Installing required gems..."
    sh 'bundle --path vendor'
  end
end
