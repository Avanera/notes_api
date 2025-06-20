class AddRewriteFieldsToNotes < ActiveRecord::Migration[8.0]
  def change
    add_column :notes, :rewrite_status, :string, default: 'original'
    add_column :notes, :rewrite_error, :text
  end
end
