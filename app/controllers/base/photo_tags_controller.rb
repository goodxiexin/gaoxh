class Base::PhotoTagsController < ApplicationController

  before_filter :login_required

  before_filter :catch_photo, :except => [:friends]

  before_filter :catch_tag, :only => [:destroy]

  before_filter :owner_required, :only => [:destroy]

  def create
    if @tag = PhotoTag.create(params[:tag].merge({:poster_id => current_user.id})
      render :update do |page|
        page.insert_html :bottom, 'photo_tags', :partial => 'base/photo_tags/tag', :object => @tag
        page << "photo_tag.after_submit_tag();"
      end
    else
      render :update do |page|
        page << "alert('错误，稍后再试');"
      end
    end
  end

  def destroy
    if @tag.destroy
      render :update do |page|
        page << "$('tag_#{@tag.id}').remove(); "
        page << "if($('name_#{@tag.id}')) $('name_#{@tag.id}').remove();"
        page << "if($('square_#{@tag.id}')) $('square_#{@tag.id}').remove();"
      end
    else
      render :update do |page|
        page << "alert('错误，稍后再试');"
      end
    end
  end

  def friends
    @friends = current_user.friends
    render :partial => 'friends', :object => @friends
  end

protected

  def catch_photo
  end

  def catch_tag
    @tag = @resource.tags.find(params[:id])
  rescue
    not_found
  end


end
