function pluralize(str){
	if(str == 'status')
		return 'statuses';
	else
		return str + 's';
}

function limit_words_of_textarea(text_area, max, count_div){
  if(text_area.value.length > max){
    text_area.value = text_area.value.substring(0, max);
    return false;
  }
  $(count_div).innerHTML = text_area.value.length + "/" + max;
}

function jump_to_comment(app, id, login){
	$(app + '_comment_content_' + id).value = "回复" + login + ":";
	$(app + '_comment_content_' + id).focus();
}

function validate_comment(content){
  if(content.value.length == 0){
    error('评论不能为空');
    return false;
  }
  if(content.value.length > 140){
    error('评论最多140个字节');
    return false;
  }
  return true;
}

function show_comment_form(app, id, login){
	$('add_' + app + '_comment_' + id).hide();
  $(app + '_comment_' + id).show();
  if(login != null)
    $(app + '_comment_content_' + id).value = "回复" + login + ":";
  $(app + '_comment_content_' + id).focus();
}

function hide_comment_form(app, id){
  $(app + '_comment_' + id).hide();
  $('add_' + app + '_comment_' + id).show();
}

function submit_comment(app, id){
  if(validate_comment($(app + '_comment_content_' + id))){
    new Ajax.Request('/' + pluralize(app) + '/' + id + '/comments', {
			method: 'post',
			parameters: $(app+'_comment_form_' + id).serialize()
		});
  }
}

function show_more_comments(app, id, link){
	link.innerHTML = '<img src="/images/loading.gif" />';
	new Ajax.Request('/' + pluralize(app) + '/' + id + '/comments', {
		method: 'get',
		onSuccess: function(transport){
			$(app + '_comments_' + id).innerHTML = transport.responseText;
		}
	});
}

function play_video(video_id, video_link){
  $('video_' + video_id).innerHTML = video_link;
}
