module TagsHelper

  def tag_cloud taggable, classes
		return if taggable.taggings.blank?
		tag_counts = taggable.taggings.group_by(&:tag_id).map do |tag_id, taggings|
			{:tag => Tag.find(tag_id), :count => taggings.count}
		end
		max_count = tag_counts.max {|a,b| a[:count] <=> b[:count]}[:count]
		tag_counts.each do |tag|
			index = (tag[:count]*(classes.size-1)/max_count).round
			yield tag[:tag], classes[index]
		end
	end

end
