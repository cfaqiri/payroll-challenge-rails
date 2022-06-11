class TimekeepingRecordsController < ApplicationController
  def index
    render json: TimekeepingRecord.all
  end
end
