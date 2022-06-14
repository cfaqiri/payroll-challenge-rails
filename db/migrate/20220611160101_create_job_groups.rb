class CreateJobGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :job_groups do |t|
      t.string :title, null: false
      t.float :rate, null: false

      t.timestamps
    end
  end
end
