class Myh

  def self.model(ma)
    ma = [ma] unless ma.is_a? Array
    ma.each do |m|
      m.attributes.each { |k,v| puts "#{k.ljust(30,'.')} #{v || 'nil'}" if v }
      puts "LAST UPDATE AT: #{m.updated_at}"
    end
  end
  
end
