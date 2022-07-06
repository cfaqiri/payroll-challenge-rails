class TimekeepingRecordsController < ApplicationController
  require 'csv'
  def index
    records = TimekeepingRecord.all
    render json: TimekeepingRecordsRepresenter.new(records).as_json
  end

  def create
    # Put transaction
    file = params["fileupload"].read
    filename = params["fileupload"].original_filename

    if ReportService.check_duplicate_report(filename)
      render status: :forbidden
      return
    end

    ReportService.save_report(filename)
    ReportService.parse_csv(file)
    render status: :created
  end

  private

end

