class ReportService

  def check_duplicate_report(filename)
    report_number = get_report_number(filename)
    Report.exists?(number: report_number)
  end

  def save_report(filename)
    report_number = get_report_number(filename)
    Report.create!(number: report_number)
  end

  def parse_csv(file)
    CSV.parse((file), headers: true) do |row|
      date = row['date'].to_datetime
      hours = row['hours worked']
      job_group = JobGroup.find_by(title: row['job group'])
      employee = Employee.find_or_create_by(number: row['employee id'], job_group: job_group)
      TimekeepingRecord.create!(date: date, hours: hours, employee: employee)
    end
  end
    # existing_report = Report.objects.filter(number=report_number, employer=user)
    # # Instead of checking the length, a more efficient function is 
    # # report.objects.find(params).exists
    # if len(existing_report) == 0:
    #     return False
    # return True

  # private

  def get_report_number(filename)
    report_number = filename[/\d+/].to_i
  end
end