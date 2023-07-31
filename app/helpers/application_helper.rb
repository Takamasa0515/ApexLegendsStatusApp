module ApplicationHelper
  def add_commas_to_number(number)
    number.to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')
  end

  def platform_image_path(platform)
    case platform
    when "origin"
      image_tag("origin_icon.png")
    when "steam"
      image_tag("steam_icon.png")
    when "psn"
      image_tag("psn_icon.png")
    when "xbl"
      image_tag("xbl_icon.png")
    end
  end

  def rank_image_path(rank)
    case rank
    when "Predator"
      image_tag("rank_images/predator.png")
    when "Master"
      image_tag("rank_images/master.png")
    when "Diamond"
      image_tag("rank_images/diamond.png")
    when "Platinum"
      image_tag("rank_images/platinum.png")
    when "Gold"
      image_tag("rank_images/gold.png")
    when "Silver"
      image_tag("rank_images/silver.png")
    when "Bronze"
      image_tag("rank_images/bronze.png")
    when "Rookie"
      image_tag("rank_images/rookie.png")
    end
  end

  def legend_name(legend_stats)
    legend_stats["metadata"]["name"]
  end

  def legend_image_path(legend_name)
    if File.exist?(Rails.root.join("app/assets/images/legend_images/#{legend_name}_icon.jpg").to_s)
      image_tag("legend_images/#{legend_name}_icon.jpg")
    else
      image_tag('legend_images/no_image.jpg')
    end
  end

  def legend_stats_value(legend_stats, stats_name, attribute)
    if legend_stats["stats"][stats_name][attribute].present?
      legend_stats["stats"][stats_name][attribute]
    else
      "---"
    end
  end
end
