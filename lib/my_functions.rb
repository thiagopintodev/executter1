#!/usr/bin/ruby -w
class MyFunctions
  def self.number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end
end
