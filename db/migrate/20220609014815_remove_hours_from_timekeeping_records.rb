class RemoveHoursFromTimekeepingRecords < ActiveRecord::Migration[7.0]
  def change
    remove_column :timekeeping_records, :hours, :decimal
  end
end
