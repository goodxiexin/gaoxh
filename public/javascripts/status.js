StatusBuilder = Class.create({

  initialize: function(form, content, count, maximum){
    this.content = content;
    this.form = form;
    this.words_count = count;
    this.maximum = maximum;
    this.words_count.innerHTML = "0/" + this.maximum;
    this.content.observe('keyup', function(field){
      if(this.content.value.length > this.maximum){
        this.content.value = this.content.value.substring(0, this.maximum);
        return false;
      }
      this.words_count.innerHTML = this.content.value.length + "/" + this.maximum;
    }.bind(this));
  },

  validate: function(){
    if(this.content.value == ''){
      error('状态不能为空');
      return false;
    }
    return true;
  },

  submit: function(){
    if(this.validate())
      new Ajax.Request('/statuses?home=0', {method: 'post', parameters: this.form.serialize()});
  }

});
