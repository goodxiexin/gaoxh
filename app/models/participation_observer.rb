class ParticipationObserver < ActiveRecord::Observer

  def user_link(user)
    user.login
  end

  def event_link(event)
    "<a href='http://localhost:3000/users/#{event.poster_id}/#{event.id}'>#{event.title}</a>"
  end

  def counter_field status
    case status
    when 0
      "invitees_count"
    when 1
      "requestors_count"
    when 2
      "requestors_count"
    when 3
      "confirmed_count"
    when 4
      "maybe_count"
    when 5
      "declined_count"
    end
  end

  def increment_counter event, status
    sql = "update events set #{counter_field status} = #{counter_field status} + 1 where id = #{event.id}"
    ActiveRecord::Base.connection.execute(sql)
  end

  def decrement_counter event, status
    sql = "update events set #{counter_field status} = #{counter_field status} - 1 where id = #{event.id}"
    ActiveRecord::Base.connection.execute(sql)
  end

  def after_create(participation)
    event = participation.event
    participant = participation.participant
    poster = event.poster

    if participation.status == 0
    elsif participation.status == 1 or participation.status == 2
    else
    end
  
    increment_counter event, participation.status
  end

  def after_update(participation)
    event = participation.event
    participant = participation.participant
    poster = event.poster

    if participation.status_was == 0
    elsif participation.status_was == 1 or participation.status_was == 2
    else
    end

    decrement_counter event, participation.status_was
    increment_counter event, participation.status
  end

  def after_destroy(participation)
    event = participation.event
    participant = participation.participant
    poster = event.poster

    # request was declined
    if participation.status_was == 1 or participation.status_was == 2
    end

    decrement_counter event, participation.status_was
  end

end
