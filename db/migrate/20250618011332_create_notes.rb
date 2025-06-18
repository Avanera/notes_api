class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes do |t|
      t.string :title
      t.text :body
      t.boolean :archived

      t.timestamps
    end
  end
end
