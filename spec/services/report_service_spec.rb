require 'rails_helper'

describe ReportService do
  describe ".check_duplicate_report" do
    let(:duplicate) { described_class.check_duplicate_report("time-report-164.csv") }

    it "returns true when report exists" do
      FactoryBot.create(:report, number: 164)
      expect(duplicate).to eq(true)
    end
  end

  describe ".get_report_number" do
    let(:number) { described_class.get_report_number("time-report-164.csv") }

    it "returns a report number from a filename" do
      expect(number).to eq(164)
    end
  end

  describe ".parse_csv" do
    FactoryBot.create(:job_group, title: 'A', rate: 20)
    FactoryBot.create(:job_group, title: 'B', rate: 30)

    it "stores timekeeping records from file in database" do
      @file = fixture_file_upload('time-report-164.csv', 'csv')
      
      expect {described_class.parse_csv(@file)}.to change {
        TimekeepingRecord.count 
      }.from(0).to(4)
    end

    context "when multiple calls are attempted at the same time" do
      context "when locked" do
        let(:mutex) { RedisMutex.new("upload-timekeeping-data-some-id-here") }

        before { mutex.lock! }
        after { mutex.unlock! }

        it 'should raise an exception' do
          @file = fixture_file_upload('time-report-164.csv', 'csv')
          expect { described_class.parse_csv(@file) }.to raise_error RedisMutex::LockError
        end
      end

      context "when not locked" do
        it 'should not raise an exception' do
          @file = fixture_file_upload('time-report-164.csv', 'csv')
          expect { described_class.parse_csv(@file) }.to_not raise_error
        end
      end
    end
  end

  describe ".save_report" do
    it "saves a report with a specified filename" do
      expect {described_class.save_report('time-report-1.csv')}.to change {
        Report.exists?(number: 1)
      }.from(false).to(true)
    end

    context "when multiple calls are attempted at the same time" do
      context "when locked" do
        let(:mutex) { RedisMutex.new("save-report-some-id-here") }

        before { mutex.lock! }
        after { mutex.unlock! }

        it 'should raise an exception' do
          expect { described_class.save_report('time-report-1.csv') }.to raise_error RedisMutex::LockError
        end
      end

      context "when not locked" do
        it 'should not raise an exception' do
          expect { described_class.save_report('time-report-1.csv') }.to_not raise_error
        end
      end
    end
  end
end