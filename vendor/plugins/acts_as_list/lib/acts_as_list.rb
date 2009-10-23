# ActsAsList
class << ActiveRecord::Base

  def acts_as_list hash_opts
    order = hash_opts[:order]
    scope = hash_opts[:scope]
    ar_class = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s.constantize   
    define_method "next" do
      item = ar_class.find(:first, :conditions => ["#{scope} = ? AND #{order} > ?", eval("#{scope}"), eval("#{order}")], :order => "#{order} ASC")
      item = ar_class.find(:first, :conditions => ["#{scope} = ?", eval("#{scope}")], :order => "#{order} ASC") if item.blank?
      return item
    end
    define_method "prev" do
      item = ar_class.find(:first, :conditions => ["#{scope} = ? AND #{order} < ?", eval("#{scope}"), eval("#{order}")], :order => "#{order} DESC")
      item = ar_class.find(:first, :conditions => ["#{scope} = ?", eval("#{scope}")], :order => "#{order} DESC") if item.blank?
      return item
    end
  end

end
