class CreateTimekeepingRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :timekeeping_records do |t|
      t.decimal :hours
      t.date :date

      t.timestamps
    end
  end
end
