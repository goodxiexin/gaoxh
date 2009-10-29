HomeManager = Class.create({

	initialize: function(id){
		this.loading_image = new Image();
		this.loading_image.src = '/images/loading.gif';
		this.feeds_div = $('feed_list');
		this.more_feeds_div = $('more_feed');
		this.time_range_id = id;
	},

	loading: function(){
		this.old_more_feeds_div = this.more_feeds_div.innerHTML;
		this.more_feeds_div.innerHTML = "<img src='" + this.loading_image.src + "'/>";
	},

	no_feeds: function(){
		this.more_feeds_div.innerHTML = '没有新鲜事了'
	},

	// hook function
	set_time_range_id: function(id){
		this.time_range_id = id;
		this.more_feeds_div.innerHTML = this.old_more_feeds_div;
	},

	show_feeds: function(type){
    this.loading();
		this.feeds_div.innerHTML = '';
		this.time_range_id = 0;
		if(type != nil){
			this.type = type;
			new Ajax.Request('/home/feeds?type=' + type, {method: 'get'});
		}else{
			new Ajax.Request('/home/feeds', {method: 'get'});
		}
	},

	more_feeds: function(){
		this.loading();
		if(this.type != nil){
			new Ajax.Request('/home/more_feeds?type=' + this.type + '&range_id=' + this.time_range_id, {method: 'get'});
		}else{
			new Ajax.Request('/home/more_feeds?range_id=' + this.time_range_id, {method: 'get'});
		}
	},

});
