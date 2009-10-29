class Profile::ProfilesController < ApplicationController

  layout 'user'

  before_filter :login_required, :setup

	after_filter :record_visiting, :only => [:show]

  before_filter :privilege_required, :only => [:show]

	before_filter :owner_required, :only => [:edit, :update]

  def show
		@comments = @profile.comments.user_viewable(current_user.id).paginate :page => params[:page], :per_page => 10
    @tagging = @profile.taggings.find_by_poster_id(current_user.id)
		@taggable = @user.friends.include?(current_user) && (@tagging.nil? || @tagging.created_at < 1.week.ago)
	end

  def edit
    case params[:type].to_i
    when 0
			render :action => 'edit'
		when 1
      render :partial => 'edit_basic_info'
    when 2
      render :partial => 'edit_contact_info'
    end
  end

  def update
    if @profile.update_attributes(params[:profile])
      case params[:type].to_i
      when 1
        render :partial => 'basic_info'
      when 2
        render :partial => 'contact_info'
      end
    end
  end

	def update_about_me
		if @profile.update_attributes(params[:profile])
			render :text => @profile.about_me
		end
	end

protected

  def setup
    @profile = Profile.find(params[:id])
		@user = @profile.user
    @setting = @user.privacy_setting
    @privilege = @setting.personal
  rescue
    not_found
  end

	def record_visiting
		return if current_user == @user
		record = @profile.visitor_records.find_by_visitor_id(current_user.id)
		if record.nil? # create a new one
			if @profile.visitor_records.count >= Profile::MAX_VISITOR_RECORDS
				@profile.visitor_records.last.destroy
			end
			@profile.visitor_records.create(:visitor_id => current_user.id)
		else # update old one
			record.update_attribute('created_at', Time.now)
		end
	end

end
