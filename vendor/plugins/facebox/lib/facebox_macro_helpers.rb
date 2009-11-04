module FaceboxMacroHelpers

  def facebox_link(msg, url, options={})
    options = options.merge({:rel => 'facebox'})
    link_to msg, url, options
  end

  def facebox_confirm(msg, url, confirm_options={}, html_options={})
    confirm_msg = confirm_options[:msg] || "你确定吗"
    confirm_method = confirm_options[:method] || 'post'
		concat = url.include?('?') ? '&' : '?'
    url += concat + "authenticity_token=#{form_authenticity_token}" if protect_against_forgery?
    options = html_options.merge({:rel => 'facebox', :facebox_confirm => confirm_msg, :facebox_method => confirm_method})
    link_to msg, url, options
  end

end
