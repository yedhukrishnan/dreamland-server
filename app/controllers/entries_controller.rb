class EntriesController < ApplicationController
  before_action :require_login!

  def create
    @entry = Entry.find_or_initialize_by(uuid: entry_params[:uuid])
    @entry.assign_attributes(entry_params)
    @entry.user = current_user
    if @entry.save
      render json: {}, status: :created
    else
      render json: { errors: @entry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
  end

  private

  def entry_params
    params.require(:entry).permit(:uuid, :text, :date, :address, :latitude, :longitude)
  end
end
