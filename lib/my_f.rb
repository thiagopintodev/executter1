class MyF
  class << self
  
    def file_type(filename)
      last = filename.split('.').last
      return :jpg if "jpg|jpeg|gif|bmp|png|psd".include? last
      return :mp3 if "mp3|wav".include? last
      return :pdf if "pdf".include? last
      return :zip if "zip|rar|gz|tar|7z".include? last
      return :doc if "docx".include? last
      return :xls if "xlsx".include? last
      return :ppt if "pptx|ppsx".include? last
      :other
    end
    
    def production?
      ENV['BUCKET_NAME'] == 'production'
    end

    def do_emails
      user_ids = DelayedMailFollowed.select("distinct user_id").limit(10).collect &:user_id
      puts "fetching #{user_ids.length} distinct emails to send --> #{Time.now}"
      user_ids.each do |user_id|
        user = User.find(user_id)
        dmf_list = DelayedMailFollowed.where(:user_id=>user_id).includes(:follower_user)
        followers_user = dmf_list.collect(&:follower_user)
        ids = dmf_list.collect(&:id)
        puts "sending #{ids.length} notifications to @#{user.email}  --> #{Time.now}"
        m = EventMailer.followed user, followers_user
        m.deliver
        DelayedMailFollowed.delete(ids)
      end
      puts "done! sending #{user_ids.length} distinct emails  --> #{Time.now}"
    end
    
  end
end
