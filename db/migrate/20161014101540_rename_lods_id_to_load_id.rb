class RenameLodsIdToLoadId < ActiveRecord::Migration[5.0]
  def change
    rename_column :orders, :loads_id, :load_id
  end
end
