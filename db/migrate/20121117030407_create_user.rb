class CreateUser < ActiveRecord::Migration

  def change
    create_table :users do |t|
      t.integer :twitter_id
      t.string  :screen_name
      t.text    :raw
      t.timestamps
    end
  end

end

