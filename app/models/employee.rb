class Employee < ApplicationRecord
  has_many :timekeeping_records
  belongs_to :job_group
end
