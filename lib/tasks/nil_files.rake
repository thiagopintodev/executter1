task :nil_files => :environment do
  user = User.first
  
  puts "nil files! --> @#{user.username}"
end
