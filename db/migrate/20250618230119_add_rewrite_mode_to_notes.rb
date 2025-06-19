class AddRewriteModeToNotes < ActiveRecord::Migration[8.0]
  def change
    add_column :notes, :rewrite_mode, :integer, default: 0
  end
end
