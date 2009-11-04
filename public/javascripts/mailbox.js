// the first javascript file i have written in my life

Mailbox = Class.create({

	initialize: function(ids, read){
		this.dropdown = $('select');
		this.mails = new Hash();
		for(var i=0;i<ids.length;i++){
			this.mails.set(ids[i], {check_box: $('mail_select_' + ids[i]), title_div: $('mail_title_' + ids[i]), read: ( read[i] == 'true' ? true:false)});
		}
	},
	
	select_dropdown_onchange: function(){
		this.mails.each(function(pair){
      pair.value.check_box.checked = false;
    }.bind(this));
		if(this.dropdown.value == 'all'){
			this.mails.each(function(pair){
				pair.value.check_box.checked = true;
			}.bind(this));
		}else if(this.dropdown.value == 'none'){
		}else if(this.dropdown.value == 'read'){
			this.mails.each(function(pair){
				if(pair.value.read)
					pair.value.check_box.checked = true;
			}.bind(this));
		}else if(this.dropdown.value == 'unread'){
			this.mails.each(function(pair){
				if(!pair.value.read)
					pair.value.check_box.checked = true;
			}.bind(this));
		}
	},
	
	get_selected_ids: function(){
		var ids = [];
    this.mails.each(function(pair){
      if(pair.value.check_box.checked){
        ids.push(pair.key);
      }
    });
		return ids;
	},

	read: function(authenticity_token){
		var ids = this.get_selected_ids();
    var params = "";
    for(var i=0;i<ids.length;i++){
      params += "ids[]=" + ids[i] + "&";
    }
    params += "authenticity_token=" + authenticity_token + "&";
    params += "type=1";
		new Ajax.Request('/mails/read_multiple', {
			method: 'put',
			parameters: params,
			onSuccess: function(transport){
				for(var i=0;i<ids.length;i++){
					this.mails.get(ids[i]).title_div.style.fontWeight = '';
					this.mails.get(ids[i]).read = true;
				}
			}.bind(this)
		}); 	
	},

	unread: function(authenticity_token){
    var ids = this.get_selected_ids();
		var params = "";
		for(var i=0;i<ids.length;i++){
			params += "ids[]=" + ids[i] + "&";
		}
		params += "authenticity_token=" + authenticity_token + "&";
		params += "type=1";
    new Ajax.Request('/mails/unread_multiple', {
      method: 'put',
      parameters: params,
      onSuccess: function(transport){
        for(var i=0;i<ids.length;i++){
          this.mails.get(ids[i]).title_div.style.fontWeight = 'bold';
					this.mails.get(ids[i]).read = false;
        }
      }.bind(this)
    });
  },

	destroy: function(authenticity_token, type){
		var ids = this.get_selected_ids();
    var params = "";
    for(var i=0;i<ids.length;i++){
      params += "ids[]=" + ids[i] + "&";
    }
    params += "authenticity_token=" + authenticity_token + "&";
    params += "type=" + type;
		new Ajax.Request('/mails/destroy_multiple', {
			method: 'delete', 
			parameters: params
		});
	}
});

function validate_mail(){
  var recipients = $('mail_recipients');
  var title = $('mail_title');
  var content = $('mail_content');
  var info = $('mail_info');
  var error = false;

  info.innerHTML = '';

  if(recipients.value == ''){
    error = true;
    info.insert('<li style="color: red">you must specify at least one recipient</li>', {position: 'bottom'});
  }
  if(title.value == ''){
    error = true;
    info.insert('<li style="color: red">title cannot be blank</li>', {position: 'bottom'});
  }
  if(content.value == ''){
    error =true;
    info.insert('<li style="color: red">content cannot be blank</li>', {position: 'bottom'});
  }

  if(!error)
    $('mail_recipients').disabled = false;

  return !error;
}


MailBuilder = Class.create({

	initialize: function(){
	},

	select_friends: function(){
	}

});
