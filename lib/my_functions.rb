#!/usr/bin/ruby -w
class MyFunctions
  def self.number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end
  
  def self.users_ids(users=[])
    users.collect { |u| (u.is_a? User) ? u.id : u }
  end
  
  def self.users(users=[])
    users.collect { |u| (u.is_a? User) ? u : User.find(u) }
  end
  
  def self.translate_hash_keys(source)
    r = {}
    source.each { |k,v| r[I18n.t k] = v }
    r
  end

  def self.model(ma)
    ma = [ma] unless ma.is_a? Array
    ma.to_yaml.split("\n").each {|a| puts a}; puts ""
  end

  def self.migrate_pa_to_x
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
  
end
