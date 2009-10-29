class TagObserver < ActiveRecord::Observer

  observe :FriendTag, :PhotoTag

  def after_save(tag)
    if tag.class.to_s == 'Ptag'
      after_photo_tag_save(tag)
    else
      eval("after_#{tag.tag_owner_type.downcase}_tag_save(tag)")
    end
  end

  def after_photo_tag_save(tag)
    receiver_setting = tag.tagged_user.mail_setting
    photo = tag.photo
    album = photo.album
    owner_setting = album.user.mail_setting

    tag.notifications.create(:user_id => tag.tagged_user_id)
    TagMailer.deliver_photo_tag(tag) if receiver_setting.tag_me_in_photo
    if album.user.id != tag.tagged_user_id and album.user.id != tag.user_id
      tag.notifications.create(:user_id => album.user.id)
      TagMailer.deliver_photo_tag_to_owner(tag) if owner_setting.tag_my_photo
    end  
  end

  def after_blog_tag_save(tag)
    tag.notifications.create(:user_id => tag.tagged_user_id)
    TagMailer.deliver_blog_tag(tag) if tag.tagged_user.mail_setting.tag_me_in_blog
  end

  def after_video_tag_save(tag)
    tag.notifications.create(:user_id => tag.tagged_user_id)
    TagMailer.deliver_video_tag(tag) if tag.tagged_user.mail_setting.tag_me_in_blog
  end

end
