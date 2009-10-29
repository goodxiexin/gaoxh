class VoteCounterObserver < ActiveRecord::Observer

	observe :vote

	def after_create(vote)
		vote.answers.each do |answer|
			answer.increment! :votes_count
		end
		vote.poll.increment! :votes_count, vote.answers.count 
	end

end
