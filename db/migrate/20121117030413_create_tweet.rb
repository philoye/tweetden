class CreateTweet < ActiveRecord::Migration

  def change
    create_table :tweets do |t|
      t.integer :id
      t.integer :user_id
      t.string  :tweet_id
      t.string  :text
      t.text    :raw
      t.timestamps
    end
  end

end
