class TimekeepingRecordsRepresenter
  include ActionView::Helpers::NumberHelper

  def initialize(timekeeping_records)
    @timekeeping_records = timekeeping_records.order(:employee_id)
  end

  def calculate_employee_reports
    employee_reports = []

    @timekeeping_records.each do |timekeeping_record|
      start_date = pay_period_start_date(timekeeping_record)
      end_date = pay_period_end_date(timekeeping_record)
      employee_id = timekeeping_record.employee_id

      # Check if report for employee and pay period exists
      report = employee_reports.find {|report| report[:employeeId] == employee_id && report[:payPeriod][:startDate] == start_date}
      
      unless report == nil
        # Unless report does not exist, update the pay
        report[:amountPaid] += amount_paid(timekeeping_record)
      else
        # For nonexistant report, create employee report 
        amount_paid = amount_paid(timekeeping_record)
        employee_reports.append(
          {
            :employeeId => employee_id,
            :payPeriod => {
              :startDate => start_date,
              :endDate => end_date
            },
            :amountPaid => amount_paid
          }
        )
      end
    end
    return employee_reports
  end

  def as_json
    # Convert pay to currency format and employee id to string
    {
      "payrollReport": {
        "employeeReports": calculate_employee_reports.each do |report|
          report[:employeeId] = report[:employeeId].to_s
          report[:amountPaid] = number_to_currency(report[:amountPaid])
        end
      }
    }
  end

  private

  attr_reader :timekeeping_records

  # Pay periods are bi-monthly (day 1-15 and 16-end of month)
  def pay_period_start_day(timekeeping_record)
    timekeeping_record.date.day < 15 ? 1 : 16
  end

  def pay_period_start_date(timekeeping_record)
    date = timekeeping_record.date
    Date.new(date.year, date.month, pay_period_start_day(timekeeping_record))
  end

  def pay_period_end_date(timekeeping_record)
    date = timekeeping_record.date
    pay_period_start_day(timekeeping_record) == 1 ? Date.new(date.year, date.month, 15) : date.end_of_month
  end

  def amount_paid(timekeeping_record)
    timekeeping_record.employee.job_group.rate * timekeeping_record.hours
  end
end