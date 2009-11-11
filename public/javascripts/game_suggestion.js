function select_game_tag(tag_name){
  var tags = $('the_game_tags').value;
  if (tags == "")
    $('the_game_tags').value = tag_name;
  else
    $('the_game_tags').value = tag_name+" , "+tags;
}

function show_tagged_games(){
  var tags = $('the_game_tags').value;
  var new_game = $('new_game').checked;
  var games_div = $('game_suggestion_area');
  if (tags == "")
    games_div.innerHTML = '请您点击游戏相关类型，以便我们向您推荐';
  else{
    var url = '/game_suggestions/game_tags?selected_tags='+tags+'&new_game='+new_game;
    new Ajax.Request(url, {
      method: 'get',
      onSuccess: function(transport){
        games_div.innerHTML = transport.responseText;
      }
    });
  }
}
