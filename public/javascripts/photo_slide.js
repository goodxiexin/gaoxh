var PhotoSlide = Class.create({
	
	initialize: function(photo_type, ids, urls, window_size, current_photo_id){
		this.window_size = window_size; 
		this.photo_type = photo_type + 's'; 
		this.loading_image = new Image();
		this.loading_image.src = '/images/loading.gif';

		this.photos = [];
		this.photo_ids = [];
		this.frames = [];

		for(var i=0;i<ids.length;i++){
			this.photo_ids.push(ids[i]);
		}
		for(var i=0;i<urls.length;i++){
			var photo = new Image();
			photo.src = urls[i];
			this.photos.push(photo);
		}                
		for(var i=0;i<this.window_size;i++){
			this.frames.push($('frame_' + i));
		}

		for(var i=0;i<this.photo_ids.length;i++){
			if(this.photo_ids[i] == current_photo_id){
				this.pos = (i - Math.floor(window_size/2) + this.photos.length) % (this.photos.length);
				break;
			}
		}
		for(var i=0;i<this.window_size;i++){
			this.loading(i);
		}
		for(var i=0;i<this.window_size;i++){
			this.load_image(i, (this.pos + i) % (this.photos.length));
		}
	},

	loading: function(idx){
		this.frames[idx].innerHTML = "<img src='" + this.loading_image.src + "'/>";
	},

	load_image: function(idx, photo_idx){
		this.frames[idx].innerHTML = "<a href='http://localhost:3000/" + this.photo_type + "/" + this.photo_ids[photo_idx] +"'><img src='" +  this.photos[photo_idx].src +"' /></a>";
	},

	next: function(){
		for(var i = 0; i < this.window_size; i++){
			this.loading(i);
		}
		this.pos = (this.pos + 1) % (this.photos.length);
		for(var i = 0; i < this.window_size; i++){
			this.load_image(i, (this.pos + i) % (this.photos.length) );
		}
	},

	prev: function(){
		for(var i = 0; i < this.window_size; i++){
			this.loading(i);
		}
		this.pos = (this.pos - 1 + this.photos.length) % (this.photos.length);
		for(var i = 0; i < this.window_size; i++){
			this.load_image(i, (this.pos + i) % (this.photos.length) );
		}
	}
});
