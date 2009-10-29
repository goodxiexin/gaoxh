class TagMailer < ActionMailer::Base

  def blog_tag(tag)
    setup_email(tag)
    @subject += "#{@user.login}在博客#{@resource.title}里标记了你"
    body[:url] = "http://localhost:3000/users/#{@user.id}/blogs/#{@resource.id}"
  end

  def video_tag(tag)
    setup_email(tag)
    @subject += "#{@user.login}在视频#{@resource.title}里标记了你"
    body[:url] = "http://localhost:3000/users/#{@user.id}/videos/#{@resource.id}"
  end

  def photo_tag(tag)
    @user = tag.user
    @tagged_user = tag.tagged_user
    @photo = tag.photo
    @album = @photo.album
    @recipients = @tagged_user.email
    @from = "gaoxh04@gmail.com"
    @sent_on = Time.now
    @subject = "Dayday3 - #{@user.login}在相册#{@album.title}里标记了你"
    body[:url] = "http://localhost:3000/albums/#{@album.id}/photos/#{@photo.id}"
  end

  def photo_tag_to_owner(tag)
    @user = tag.user
    @tagged_user = tag.tagged_user
    @photo = tag.photo
    @album = @photo.album
    @from = "gaoxh04@gmail.com"
    @sent_on = Time.now
    @recipients = @album.user.email
    @subject = "Dayday3 - #{@user.login}在你的相册#{@album.title}里标记了#{@tagged_user.login}"
    body[:url] = "http://localhost:3000/albums/#{@album.id}/photos/#{@photo.id}"
  end

protected

  def setup_email(tag)
    @user = tag.user
    @tagged_user = tag.tagged_user
    @resource = tag.tag_owner
    @recipients = @tagged_user.email
    @from = "gaoxh04@gmail.com"
    @subject = "Dayday3 - "
    @sent_on = Time.now
  end

end
