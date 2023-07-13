module ApplicationHelper
  def legend_image_path(legend_name)
    if File.exist?(Rails.root.join("app/assets/images/legend_images/#{legend_name}_icon.jpg").to_s)
      image_tag("legend_images/#{legend_name}_icon.jpg")
    else
      image_tag('legend_images/no_image.jpg')
    end
  end

  def platform_image_path(platform)
    if platform == "origin"
      image_tag("origin_icon.png")
    elsif platform == "steam"
      image_tag("steam_icon.png")
    elsif platform == "psn"
      image_tag("psn_icon.png")
    elsif platform == "xbl"
      image_tag("xbl_icon.png")
    end
  end
end
