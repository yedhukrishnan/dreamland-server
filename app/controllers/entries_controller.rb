class EntriesController < ApplicationController
  before_action :require_login!

  def create
    @entries = entries_params.map do |entry_params|
      entry = Entry.find_or_initialize_by(uuid: entry_params[:uuid])
      entry.user = current_user
      entry.assign_attributes(entry_params)
      entry
    end

    success = @entries.map(&:save)
    if success.all?
      render json: {}, status: :created
    else
      render json: {
        success: @entries.select{ |entry| entry.errors.blank? }.map(&:uuid),
        error: @entries.select{ |entry| !entry.errors.blank? }.map(&:uuid)
      }, status: :unprocessable_entity
    end
  end

  def index
    @entries = Entry.where(user: current_user).order('date desc')
    render json: { entries: @entries }
  end

  private

  def entries_params
    params.permit(entry: [:uuid, :text, :date, :address, :latitude, :longitude])[:entry]
  end
end
