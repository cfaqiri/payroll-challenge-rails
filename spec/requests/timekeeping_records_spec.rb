require 'rails_helper'

describe 'Payroll API', type: :request do
  let!(:first_job_group) do
    FactoryBot.create(:job_group, title: 'A', rate: 20)
  end

  let!(:second_job_group) do
    FactoryBot.create(:job_group, title: 'B', rate: 30)
  end

  let(:first_employee) do
    FactoryBot.create(:employee, number: 1, job_group: first_job_group)
  end

  let(:second_employee) do
    FactoryBot.create(:employee, number: 2, job_group: second_job_group)
  end

  describe "GET /books" do
    it 'returns all timekeeping records' do
      FactoryBot.create(
        :timekeeping_record, 
        employee: first_employee, 
        date: Date.new(2023, 1, 4),
        hours: 10
      )

      FactoryBot.create(
        :timekeeping_record, 
        employee: first_employee, 
        date: Date.new(2023, 1, 14),
        hours: 5
      )

      FactoryBot.create(
        :timekeeping_record, 
        employee: second_employee, 
        date: Date.new(2023, 1, 20),
        hours: 3
      )

      FactoryBot.create(
        :timekeeping_record, 
        employee: first_employee, 
        date: Date.new(2023, 1, 20),
        hours: 4
      )

      get '/timekeeping_records'

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq(
        {
          "payrollReport": {
              "employeeReports": [
                  {
                      "employeeId": "1",
                      "payPeriod": {
                          "startDate": "2023-01-01",
                          "endDate": "2023-01-15"
                      },
                      "amountPaid": "$300.00"
                  },
                  {
                      "employeeId": "1",
                      "payPeriod": {
                          "startDate": "2023-01-16",
                          "endDate": "2023-01-31"
                      },
                      "amountPaid": "$80.00"
                  },
                  {
                      "employeeId": "2",
                      "payPeriod": {
                          "startDate": "2023-01-16",
                          "endDate": "2023-01-31"
                      },
                      "amountPaid": "$90.00"
                  }
              ]
          }
        }.with_indifferent_access
      )
    end
  end

  describe "POST /books" do
    it 'uploads a file of timekeeping data' do
      @file = fixture_file_upload('time-report-164.csv', 'csv')
      
      post "/timekeeping_records", params:{fileupload: @file}
      
      expect(response).to have_http_status(:created)
    end

    it 'returns forbidden status when uploading duplicate report' do
      FactoryBot.create(:report, number: 164)

      @file = fixture_file_upload('time-report-164.csv', 'csv')
      
      post "/timekeeping_records", params:{fileupload: @file}
      expect(response).to have_http_status(:forbidden)
    end
  end
end