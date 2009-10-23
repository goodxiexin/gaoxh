module EmotionMacroHelpers

  def emotion_link text_area_id
    link_to_function "表情", "emotion_converter.bind(this, '#{text_area_id}');emotion_converter.show_faces(this);"
  end

end
