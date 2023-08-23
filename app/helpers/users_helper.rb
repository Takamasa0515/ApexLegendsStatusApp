module UsersHelper
  def legend_stats_value(legend_stats, stats_name, attribute)
    (legend_stats["stats"][stats_name][attribute].presence || "---")
  end
end
