var Facebox = Class.create({
	initialize: function(extra_set){
		this.settings = {
			loading_image	: '/images/loading.gif',
			image_types		: new RegExp('\.' + ['png', 'jpg', 'jpeg', 'gif'].join('|') + '$', 'i'),
			inited				: true,	
			facebox_html	: '\
	  			<div id="facebox" style="display:none;"> \
	    			<div class="popup"> \
	      			<table id="facebox_table"> \
	        		<tbody> \
	          			<tr><td class="tl"/><td class="b"/><td class="tr"/></tr> \
	          			<tr><td class="b"/><td class="body"></td><td class="b"/></tr> \
	          			<tr><td class="bl"/><td class="b"/><td class="br"/></tr> \
	        		</tbody> \
	      			</table> \
	    			</div> \
	  			</div>'
		};
		if (extra_set) Object.extend(this.settings, extra_set);
		$(document.body).insert({bottom: this.settings.facebox_html});
	
		this.preload = [];
		this.loading_image = new Image();
		this.loading_image.src = this.settings.loading_image;	
		
		f = this;
		$$('#facebox .b:first, #facebox .bl, #facebox .br, #facebox .tl, #facebox .tr').each(function(elem){
			f.preload.push(new Image());
			f.preload.slice(-1).src = elem.getStyle('background-image').replace(/url\((.+)\)/, '$1');
		});
		
		this.facebox = $('facebox');
    		this.keyPressListener = this.watchKeyPress.bindAsEventListener(this);
		
		this.watchClickEvents();
		fb = this;
	},
	
  	watchKeyPress: function(e){
    		// Close if espace is pressed or if there's a click outside of the facebox
    		if (e.keyCode == 27 || !Event.element(e).descendantOf(this.facebox)) this.close();
  	},
	
	watchClickEvents: function(){
		var f = this;
		$$('a[rel=facebox]').each(function(elem,i){
			Event.observe(elem, 'click', function(e){
				Event.stop(e);
				f.click_handler(elem, e);
			});
		});
	},

	watchClickEvent: function(elem){
		var f = this;		
		Event.observe(elem, 'click', function(e){
			Event.stop(e);
			f.click_handler(elem, e);
		});
	},
	
	loading: function() {
		if ($$('#facebox .loading').length == 1) return true;
		
		bodyWrapper = $$('#facebox .body').first();
		bodyWrapper.childElements().each(function(elem, i){
			elem.remove();
		});
		bodyWrapper.innerHTML = '<div class="loading"><img src="'+this.loading_image.src+'"/></div>';
		
		var pageScroll = document.viewport.getScrollOffsets();
		this.facebox.setStyle({
			'top': pageScroll.top + (document.viewport.getHeight()/4) + 'px',
			'left': document.viewport.getWidth() / 2 - (this.facebox.getWidth() / 2) + 'px',
		});
    		
		//Event.observe(document, 'keypress', this.keyPressListener);
    		//Event.observe(document, 'click', this.keyPressListener);
	},
	
	remove_loading: function(){
		this.loading();
		load = $$('#facebox .loading').first();
		if(load) load.remove();
	},

	locate: function(){
		var pageScroll = document.viewport.getScrollOffsets();
		this.facebox.setStyle({
			'top': pageScroll.top + (document.viewport.getHeight() / 5) + 'px',
			'left': document.viewport.getWidth() / 2 - (this.facebox.getWidth() / 2) + 'px'
		});
	},

	set_content: function(data, klass){
		bodyWrapper = $$('#facebox .body').first();
		if (klass) bodyWrapper.addClassName(klass);
		bodyWrapper.innerHTML = data;
    		$$('#facebox .body').first().childElements().each(function(elem,i){
     			elem.show();
    		});
    		
		if(!this.facebox.visible()) new Effect.Appear(this.facebox, {duration: .3});
	},

	reveal: function(data, klass){
		this.remove_loading();
		this.set_content(data, klass);
		this.locate();
    
		//Event.observe(document, 'keypress', this.keyPressListener);
    		//Event.observe(document, 'click', this.keyPressListener);
	},

        show_notice: function(info){
        	var html = "<div class='header'><h3>提示</h3></div><div class='content'>" + info + "</div>";
          	
 		this.remove_loading();
		this.set_content(html);
		this.locate();

           	setTimeout("facebox.close();", 1500);
        },

        show_error: function(info){
        	var html = "<div class='error-header'><h3>错误提示</h3></div><div class='content'>" + info + "</div>";
          
		this.remove_loading();
		this.set_content(html);
		this.locate();

           	setTimeout("facebox.close();",1500);
        },

	show_confirm: function(confirm_message, url, method){
		var html = "<div class='header'><h3>请确认</h3></div><div class='content'>" + confirm_message + "</div>";
		html += "<div class='footer'><input class='confirm-button'  onclick=\"new Ajax.Request('" + url +"', {method: '" + method + "', onSuccess: function(){}});\" value='确定' type='button'><input class='cancel-button' onclick='facebox.close();' value='取消' type='button'></div>";
		this.remove_loading();
		this.set_content(html);
		this.locate();
	},
	
	close: function(){
		 new Effect.Fade('facebox', {duration: .3});
	},

	click_handler	: function(elem, e){
		this.loading();
		Event.stop(e);

		// support for rel="facebox[.inline_popup]" syntax, to add a class
		var klass = elem.rel.match(/facebox\[\.(\w+)\]/);
		if (klass) klass = klass[1];
		
		new Effect.Appear(this.facebox, {duration: .3});
	
		if (elem.href.match(/#/)){
			var url = window.location.href.split('#')[0];
			var target = elem.href.replace(url+'#','');
			var d = $(target);
			var data = new Element(d.tagName);
			data.innerHTML = d.innerHTML;
			this.reveal(data, klass);
		} else if (elem.href.match(this.settings.image_types)) {
			var image = new Image();
			fb = this;
			image.onload = function() {
				fb.reveal('<div class="image"><img src="' + image.src + '" /></div>', klass)
			}
			image.src = elem.href;
		} else {
			var fb  = this;
			var confirm_message = elem.readAttribute('facebox_confirm');

			if(confirm_message){
        var start_idx = elem.href.indexOf('authenticity_token=');
        var end_idx = elem.href.indexOf('&', start_idx);
        var url = '';
        if(end_idx < 0){
          url = elem.href.substring(0, start_idx) + encodeURIComponent(elem.href.substring(start_idx));
        }else{
          url = elem.href.substring(0, start_idx) + encodeURIComponent(elem.href.substring(start_idx, end_idx)) + elem.href.substring(end_idx);
        }

				fb.show_confirm(confirm_message, url, elem.readAttribute('facebox_method'));
			}else{
				new Ajax.Request(elem.href, {
					method: 'get',
					onFailure: function(transport){
						fb.reveal(transport.responseText, klass);
					},
					onSuccess: function(transport){
						fb.reveal(transport.responseText, klass);
					}
				});
			}
		}
	}
});

var facebox;

document.observe('dom:loaded', function(){
	facebox = new Facebox();
	
 	// override default alert
	//window.alert = function(mess){
  	//	return facebox.show_notice(mess);
	//};

	// add a shortcut to facebox.show_error
	window.error = function(mess) {
  		return facebox.show_error(mess);
	};
});
