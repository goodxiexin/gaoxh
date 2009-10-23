module InPlaceEditorMacroHelpers
 
  DEFAULT_TEXT_FIELD_OPTIONS = {
	:okControl => false, 
	:cancelControl => false, 
	:submitOnBlur => true, 
	:rows => 1, 
	:cols => 70, 
	:clickToEditText => "'点击更新'", 
	:savingText => "'正在更新...'"}

  def in_place_text_field(obj, method, options={})
    class_name = obj.class.to_s.underscore
    logger.error "class_name = #{class_name}"
    parameters = options.delete(:parameters)
    url = options.delete(:url) || eval("#{class_name}_url(obj)")
    value_name = options.delete(:name) || "#{class_name}[#{method}]"
    callback = "function(form, value) { return '#{value_name}=' + value"
    callback += " + '&authenticity_token=#{form_authenticity_token}'" if protect_against_forgery?
    callback += "; }"

    # construct tag
    tag_value = eval("obj.#{method}").blank? ? '' : eval("obj.#{method}") 
    tag = "<div id='#{class_name}_#{method}_#{obj.id}'>" + tag_value + "</div>"

    # construct inplace editor
    options = DEFAULT_TEXT_FIELD_OPTIONS.merge options
    options[:callback] = callback
    options[:ajaxOptions] = options_for_javascript({:method => "'put'"})
    options[:emptyText] = "'#{options.delete(:empty_text)}'" if options[:empty_text]
    options[:emptyClassName] = "'#{options.delete(:empty_class_name)}'" if options[:empty_class_name] 
    ajax = javascript_tag "new Ajax.InPlaceEditorWithEmptyText('#{class_name}_#{method}_#{obj.id}', '#{url}', #{options_for_javascript options});"
    
    return tag + ajax
  end

end
