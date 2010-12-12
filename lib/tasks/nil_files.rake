task :nil_files => :environment do
  User.all.each do |user|
    user.background_image = nil
    user.save
  end
  puts "User done!"
  PostAttachment.delete_all
  puts "PostAttachment done!"
  Photo.delete_all
  puts "Photo done!"
  Banner.delete_all
  puts "Banner done!"
end
