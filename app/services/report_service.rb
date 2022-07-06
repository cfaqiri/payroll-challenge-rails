class ReportService
  def self.check_duplicate_report(filename)
    report_number = get_report_number(filename)
    Report.exists?(number: report_number)
  end

  def self.get_report_number(filename)
    report_number = filename[/\d+/].to_i
  end

  def self.parse_csv(file)
    CSV.parse((file), headers: true) do |row|
      date = row['date'].to_datetime
      hours = row['hours worked']
      job_group = JobGroup.find_by(title: row['job group'])
      employee = Employee.find_or_create_by(number: row['employee id'], job_group: job_group)
      TimekeepingRecord.create!(date: date, hours: hours, employee: employee)
    end
  end

  def self.save_report(filename)
    report_number = get_report_number(filename)
    Report.create!(number: report_number)
  end
end