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
end
