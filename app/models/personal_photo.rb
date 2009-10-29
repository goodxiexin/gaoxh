class PersonalPhoto < Photo

  
  before_create :set_album_info


protected
  
  def set_album_info
    self.game_id = album.game_id
  end


end
