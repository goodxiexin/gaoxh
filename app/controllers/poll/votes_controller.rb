class Poll::VotesController < ApplicationController

  before_filter :login_required, :setup

  before_filter :privilege_required 

  def create
    params[:votes].each do |answer_id|
      @poll.votes.create(:poll_answer_id => answer_id, :subscriber_id => current_user.id)
    end
    @poll.increment!(:subscribers_count) # a hack
    redirect_to poll_url(@poll)
  end

protected

  def setup
    @poll = Poll.find(params[:poll_id])
    @user = @poll.poster
    @privilege = @poll.privilege
  rescue
    not_found
  end

end
