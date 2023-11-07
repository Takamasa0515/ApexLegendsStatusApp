class TrackerMatchRecordsController < ApplicationController
  before_action :set_beginning_of_week

  def index
    @user = User.find(params[:user_id])
    @game_account_info = @user.game_account_info
    @game_account_info.present? ? api_request_check : @match_histories = "No account"
    @matches = TrackerMatchRecord.where(user_id: @user.id)
  end

  def show_records
    @match_date = params[:match_date]
    @match_ids = params[:match_ids]
    @day_matches = @match_ids.present? ? TrackerMatchRecord.find(@match_ids) : nil
    render turbo_stream: turbo_stream.replace(
      "record",
      partial: 'tracker_match_records/day_record',
      locals: { day_matches: @day_matches, match_date: @match_date }
    )
  end

  private

  def set_beginning_of_week
    Date.beginning_of_week = :sunday
  end

  def api_request_check
    last_accessed_at = @user.last_accessed_at_match_record
    current_time = Time.zone.now
    if last_accessed_at.present?
      time_difference = (current_time - last_accessed_at).to_i
      api_request_and_save if time_difference >= 600
    else
      api_request_and_save
    end
  end

  def api_request_and_save
    @match_histories = TrackerMatchRecord.fetch_trn_match_history(@game_account_info)
    return @match_histories unless @match_histories.include?("data")

    TrackerMatchRecord.save_past_match_histories(@match_histories, @user) if @match_histories.include?("data")
    @user.update(last_accessed_at_match_record: Time.zone.now)
  end
end
