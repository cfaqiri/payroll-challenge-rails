class TimekeepingRecordsController < ApplicationController
  require 'csv'
  def index
    render json: TimekeepingRecord.all
  end

  def create
    file = params["fileupload"].read
    filename = params["fileupload"].original_filename
    report_service = ReportService.new

    if report_service.check_duplicate_report(filename)
      render status: :forbidden
      return
    end

    report_service.parse_csv(file)

    # Move this to a service
  
    
    render status: :created
    # Do some error checking here for the file name and duplication
  end

  private

end

