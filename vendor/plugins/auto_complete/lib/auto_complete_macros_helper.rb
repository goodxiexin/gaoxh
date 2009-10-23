module AutoCompleteMacrosHelper

  def auto_complete_field(field_id, options = {})
    function = "var #{field_id}_auto_completer = new Ajax.Autocompleter("
    function << "'#{field_id}', "
    function << "'" + (options[:update] || "#{field_id}_auto_complete") + "', "
    function << "'#{url_for(options[:url])}'"
    
    js_options = {}
    js_options[:tokens] = array_or_string_for_javascript(options[:tokens]) if options[:tokens]
    js_options[:callback] = "function(element, value) { return #{options[:with]} }" if options[:with]
    js_options[:indicator] = "'#{options[:indicator]}'" if options[:indicator]
    js_options[:select] = "'#{options[:select]}'" if options[:select]
    js_options[:paramName] = "'#{options[:param_name]}'" if options[:param_name]
    js_options[:frequency] = "#{options[:frequency]}" if options[:frequency]
    js_options[:method] = "'#{options[:method].to_s}'" if options[:method]
    if protect_against_forgery?
      js_options[:parameters] = "\"authenticity_token=#{form_authenticity_token}\""
    end
 
    { :after_update_element => :afterUpdateElement,
      :on_show => :onShow, :on_hide => :onHide, :min_chars => :minChars }.each do |k,v|
      js_options[v] = options[k] if options[k]
    end
 
    function << (', ' + options_for_javascript(js_options) + ')')
 
    javascript_tag(function)
  end

  def auto_complete_text_field(object, method, url, tag_options = {}, completion_options = {})
    text_field(object, method, tag_options) +
    content_tag("div", "", :id => "#{object}_#{method}_auto_complete", :class => "autocomplete") +
    auto_complete_field("#{object}_#{method}", { :url => url }.merge(completion_options))
  end

end
