class Array
  # returning a hash,not array
  def extract_to_hash(keys_array)
    ret_hash={}
    keys_array.each {|ky| ret_hash[ky.to_sym]=[]}
    self.each do |sf|
      keys_array.each do |ky|
        ret_hash[ky.to_sym] << sf.sub("#{ky}_","") if sf =~ Regexp.new("^#{ky}")
      end
    end
    ret_hash.reject { |k,v| v.blank? }
  end
end