class GameSuggestionsController < ApplicationController
  layout 'app2'
  before_filter :login_required

  def index
    @game_tags = Tag.find(:all, :conditions => ["taggable_type = 'Game'"])
    @game_attentions = current_user.game_attentions
    @game_list = Game.find(:all, :conditions => ["sale_date > ?",Date.today]).sort{|a,b| b.game_attentions.size <=> a.game_attentions.size}
    @beta_list = Game.find(:all, :conditions => ["sale_date > ?",Date.today]).sort{|a,b| a.sale_date <=> b.sale_date}
  end

  def game_tags
    @new_game_flag = params[:new_game]
    @tagged_games = Game.find_tagged_with(params[:selected_tags])
    # if new game is checked, 只有6个月之内退出的游戏或者还没退出的游戏会被推荐
    if (@new_game_flag == 'true')
        @tagged_games = @tagged_games.select{|game| game.sale_date.nil? or game.sale_date > Date.today<<(6)}
    end

    unless @tagged_games.empty?
      @games = self.game_suggestion
    end
    render :partial => "games", :object => @games[0..5]
  end

  def game_suggestion
    # giving scores to each game that user has played before
    tag_score = {}
    tag_score.default = 0
    @current_games=[]
    current_user.characters.each do |game_character|
      @current_games << game_character.game
      game_character.game.tags.each do |tag|
        tag_score[tag.id] += (game_character.game.get_rating_from_user(current_user) - 3)
      end
    end

    # giving scores to all tag related games
    game_score = {}
    game_score.default = 0
    @tagged_games.each do |game|
      game.tags.each do |tag|
        game_score[game.id] += tag_score[tag.id]
      end
    end

    # giving final scores from personal score 60% and user ratings (attention) 40%
    max_score = game_score.values.max
    max_score = [1, max_score].max
    max_attention = @tagged_games.sort{|a,b| b.game_attentions.size <=> a.game_attentions.size}.first.game_attentions.size
    max_attention = [1, max_attention].max #prevent this values 0
    @tagged_games.each do |game|
      if game.new_game?
        game_score[game.id] = (6 * game_score[game.id]/max_score)+(4 * game.game_attentions.size/max_attention)
      else
        game_score[game.id] = (6 * game_score[game.id]/max_score)+(0.8 * game.rating)
      end
    end

    logger.error(game_score.first[1])

    # return games with score order
    game_scores = game_score.sort{|a,b| b[1] <=> a[1]}
    @games = []
    game_scores.each do |game_list|
      game = Game.find(game_list[0])
      unless (@current_games.include?(game) or current_user.interested_in_game?(game) )
        @games << game
      end
    end
    return @games
  end

  def add_attention
    @game = Game.find(params[:game_id])
    @game.game_attentions.create(:user_id => current_user.id)
  end

  def attention_destroy
    @game_attention = GameAttention.find(params[:game_attention_id])
    @game_attention.destroy
      render :update do |page|
        page.redirect_to game_suggestions_url()
      end
  end
end
