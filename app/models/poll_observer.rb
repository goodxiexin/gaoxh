class PollObserver < ActiveRecord::Observer

  def after_update(poll)
    if poll.summary_changed?
      poll.subscribers.each do |subscriber|
        if subscriber.mail_setting.poll_summary_change and subscriber != poll.poster
          #PollMailer.deliver_summary_change(poll, subscriber)
        end
      end
    end
  end

end
