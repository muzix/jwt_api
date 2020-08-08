class AddNameToStream < ActiveRecord::Migration[5.2]
  def change
    add_column :streams, :name, :string
  end
end
