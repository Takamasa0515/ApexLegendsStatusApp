module ApplicationHelper
  def legend_image_path(legend_name)
    if File.exist?("#{Rails.root}/app/assets/images/legend_images/#{legend_name}_icon.jpg")
      image_tag("legend_images/#{legend_name}_icon.jpg")
    else
      image_tag("legend_images/no_image.jpg")
    end
  end
end
