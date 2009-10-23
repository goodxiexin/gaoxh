class PhotoObserver < ActiveRecord::Observer

  observe :Avatar, :PersonalPhoto

  def after_destroy(photo)
    eval("after_#{photo.class.to_s.underscore}_destroy(photo)")
  end

  def after_avatar_destroy(avatar)
    user = avatar.user
    if user.avatar_id == avatar.id
      user.update_attribute('icon_id', nil)
    end
  end

  def after_personal_photo_destroy(photo)
    album = photo.album
    if album.cover_id == photo.id
      album.update_attribute('cover_id', nil)
    end
  end

  def after_event_photo_destroy(photo)
    album = photo.album
    if album.cover_id == photo.id
      album.update_attribute('cover_id', nil)
    end
  end

  def after_guild_photo_destroy(photo)
    album = photo.album
    if album.cover_id == photo.id
      album.update_attribute('cover_id', nil)
    end
  end

end
