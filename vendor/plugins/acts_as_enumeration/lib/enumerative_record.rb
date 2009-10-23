class << ActiveRecord::Base

  def acts_as_enumeration options
    options.each do |column, statuses|
      statuses.each_with_index do |status, i|
        define_method("is_#{status}?") do
          eval("#{column} == #{i}")
        end
      end
    end
  end

end
