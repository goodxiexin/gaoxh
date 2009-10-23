ProfileManager = Class.create({

  initialize: function(user_id){
    this.user_id = user_id;
    this.loading_image = new Image();
    this.loading_image.src = "/images/loading.gif";
    this.basic_info = $('basic_info');
    this.basic_info_head = this.basic_info.childElements()[0];
    this.basic_info_body = this.basic_info.childElements()[1];
    this.contact_info = $('contact_info');
    this.game_info = $('game_info');
  },

  edit_basic_info: function(){
    // change css class of this.basic_info_head
    this.old_basic_info = this.basic_info_body.innerHTML;
    if(this.basic_info_form){
      this.basic_info_body.innerHTML = this.basic_info_form;
    }else{
      this.basic_info_body.innerHTML = "<div><img scr='" + this.loading_image.src + "' /></div>";    
      new Ajax.Request('/profiles/' + this.user_id + '/edit?type=0', {
        method: 'get',
        onSuccess: function(transport){
          this.basic_info_form = transport.responseText;
          this.basic_info_body.innerHTML = this.basic_info_form;
        }.bind(this)
      });
    }
  },

  leave_edit_basic_info: function(){
    this.basic_info_body.innerHTML = this.old_basic_info; 
  },

  validate_basic_info: function(){
    return true;
  },

  update_basic_info: function(){
    if(this.validate_basic_info()){
      new Ajax.Request('/profiles/' + this.user_id, {
        method: 'put',
        parameters: $('basic_info_form').serialize(),
        onSuccess: function(transport){
          this.basic_info_form = null;
          //this.basic_info_head
          this.basic_info_body.innerHTML = transport.responseText;
        }.bind(this)
      });
    }
  },

  edit_contact_info: function(){
  },

  update_contact_info: function(){
  },

  edit_game_info: function(){
  },

  update_game_info: function(){
  }

});
