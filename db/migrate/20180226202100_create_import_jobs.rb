class CreateImportJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :import_jobs do |t|
      t.string :input_file
      t.string :errors_file
      t.string :state
      t.string :jid
      t.string :type

      t.timestamps
    end
  end
end
