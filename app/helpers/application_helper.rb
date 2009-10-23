# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def avatar_image(user, size="small")
    if user.avatar.blank?
      image_tag "default_#{size}.png"
    else
      image_tag user.avatar.public_filename(size)
    end
  end

  def avatar(user, size="small")
    if user.avatar.blank?
      link_to image_tag("default_#{size}.png"), :popup => true
    else
      link_to image_tag(user.avatar.public_filename(size)), :popup => true
    end
  end

  def profile_link(user)
    link_to user.login, :popup => true
  end

  def validation_image
    "<img src='/application/new_validation_image' onclick='alert(\"begin\");this.src=\"/application/new_validation_image\";alert(\"done\");' />"
  end

  def ftime(time)
    time.strftime("%Y-%m-%d %H:%M") unless time.blank?
  end

  def ftime2(time)
    time.strftime("%Y-%m-%d") unless time.blank?
  end

  def ftime3(time)
    time.strftime("%m-%d") unless time.blank?
  end

  def ftime4(time)
    time.strftime("%H: %M") unless time.blank?
  end

  def gender_select_tag user
    select_tag "user[gender]", options_for_select([['男', 'male'], ['女', 'female']], user.gender) 
  end
  
  def privilege_select_tag(object)
    select_tag "#{object}[privilege]", options_for_select([['所有人', 1], ['好友及玩相同游戏的朋友', 2], ['好友', 3], ['自己', 4]], eval("@#{object}.privilege"))
  end

  def privacy_select_tag(obj, field)
    select_tag "#{obj}[#{field}]", options_for_select([['所有人', 1],  ['好友及玩相同游戏的朋友', 2], ['好友', 3]], eval("@#{obj}.#{field}"))
  end

  def friend_privacy_select_tag(obj, field)
    select_tag "#{obj}[#{field}]", options_for_select([['所有人', 1],  ['玩相同游戏的朋友', 2]], eval("@#{obj}.#{field}"))
  end

  def poll_privilege_select_tag(object)
    select_tag "#{object}[privilege]", options_for_select([['所有人', 1], ['好友', 2]], eval("@#{object}.privilege"))
  end

  def get_subject(user)
    if(current_user == user)
      "我"
    else
      if user.gender == 'male'
        "他"
      else
        "她"
      end
    end
  end

  def album_cover(album, size="medium")
    if album.cover_id.blank?
      link_to image_tag("default_cover_#{size}.jpg"), eval("#{album.class.to_s.underscore}_url(album)")
    else
      link_to image_tag(album.cover.public_filename(:medium)), eval("#{album.class.to_s.underscore}_url(album)")
    end
  end

  def album_link album
    link_to (truncate album.title, :length => 20), eval("#{album.type.underscore}_url(album)")
  end

  def photo_link(photo, size="medium")
    link_to (image_tag photo.public_filename(size)), eval("#{photo.type.underscore}_url(photo)")
  end

  def dig_link diggable
    (link_to_remote '挖', :url => eval("#{diggable.class.to_s.underscore}_digs_url(diggable)")) + 
    "(<span id='dig_#{diggable.class.to_s.underscore}_#{diggable.id}'>#{diggable.digs_count}</span>)"
  end

  def game_link game
    link_to game.name
  end

  def event_link event
    link_to (truncate event.title, :length => 20), event_url(event)
  end

end
