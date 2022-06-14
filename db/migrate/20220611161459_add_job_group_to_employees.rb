class AddJobGroupToEmployees < ActiveRecord::Migration[7.0]
  def change
    add_reference :employees, :job_group, null: false, foreign_key: true
  end
end
