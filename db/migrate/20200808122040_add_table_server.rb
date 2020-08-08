class AddTableServer < ActiveRecord::Migration[5.2]
  def change
    create_table :servers do |t|
      t.string :ip
    end

    add_index :servers, :ip, unique: true
  end
end
