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
    report_service = ReportService.new

    if report_service.check_duplicate_report(filename)
      render status: :forbidden
      return
    end

    report_service.save_report(filename)
    report_service.parse_csv(file)
    render status: :created
  end

  private

end

