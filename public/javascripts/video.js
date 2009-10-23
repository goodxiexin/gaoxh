VideoBuilder = Class.create({
  
  initialize: function(title, url, privilege, category, form, tag_builder){
    this.title = $(title);
    this.url = $(url);
    this.privilege = $(privilege);
    this.category = $(category);
    this.form = $(form); 
    this.tag_builder = tag_builder;
  },

  valid: function(){
    if(this.title.value == ''){
      error('标题不能为空');
      return false;
    }
    if(this.url.value == ''){
      error('url不能为空');
      return false;
    }
    if(this.category.value == ''){
      error('游戏类别不能为空');
      return false;
    }
    if(this.title.length >= 100){
      facebox.show_error('标题太长了，最长100个字符');
      return false;
    }
    return true;   
  },

  save: function(){
    if(this.valid()){
      var new_tags = this.tag_builder.get_new_tags();
      for(var i=0;i<new_tags.length;i++){
        var el = new Element("input", {type: 'hidden', value: new_tags[i], id: 'video[tags][]', name: 'video[tags][]' });
        this.form.appendChild(el);
      }
      this.form.submit();
    } 
  }

});
