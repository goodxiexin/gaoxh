function limit_words_of_text_area(text_area, max, count_div){
  if(text_area.value.length > max){
    text_area.value = text_area.value.substring(0, max);
    return false;
  }
  count_div.innerHTML = text_area.value.length + "/" + max;
}
