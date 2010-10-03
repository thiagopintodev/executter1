class ActiveRecord::Base

  def to_table
    self.attributes.each { |k,v| puts "#{k.ljust(30,'.')} #{v || 'nil'}" }
    "LAST UPDATE AT: #{updated_at}"
  end
  
end
