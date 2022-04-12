class CreatePins < ActiveRecord::Migration[6.0]
  def change
    create_table :pins do |t|
      t.string :cid, null: false
      t.string :name, :limit => 255
      t.json :origins
      t.json :meta
      t.string :status, default: 'queued'
      t.json :delegates

      t.timestamps
    end
  end
end
