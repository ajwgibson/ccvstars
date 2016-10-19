module HasSortableName
  
  extend ActiveSupport::Concern


    def name
      result = "#{last_name}, #{first_name}"
      result = result.chomp(', ')
      result = result.reverse.chomp(',').reverse
      result.strip
    end
    
  
end