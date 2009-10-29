class Avatar < Photo

	after_create :update_user_and_album

protected

	def update_user_and_album
		album.update_attribute('cover_id', id)
		album.user.update_attribute('avatar_id', id)
	end

end
