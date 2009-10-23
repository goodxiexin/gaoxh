class PhotoTag < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :photo

end
