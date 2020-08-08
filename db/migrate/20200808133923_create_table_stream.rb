class CreateTableStream < ActiveRecord::Migration[5.2]
  def change
    create_table :streams do |t|
      t.references :user, index: true
      t.references :server, index: true
    end
  end
end
