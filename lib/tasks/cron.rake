desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
   puts "Sending followed e-mails..."
   DelayedMailFollowed.send_them
   puts "done."
end
