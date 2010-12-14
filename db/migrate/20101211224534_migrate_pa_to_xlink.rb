#encode: utf-8
class MigratePaToXlink < ActiveRecord::Migration
  def self.up

    Post.all.each do |p|
      p.post_attachments.all.each do |pa|
        if pa.file?
          x = Xlink.new
          x.file = pa.file
          x.file_width = pa.file_width
          x.file_height = pa.file_height
          x.user_id = p.user_id
          x.save
          p.links = [ {:url=>x.to_url, :name => pa.file_file_name} ]
          p.save
          pa.destroy
        end
      end
    end

  end

  def self.down
    puts "I didn't plan to be a going back from this"
  end
end
