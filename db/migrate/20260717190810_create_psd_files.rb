class CreatePsdFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :psd_files do |t|
      t.string :title
      t.text :description
      t.jsonb :metadata, default: {}

      t.timestamps
    end
  end
end
