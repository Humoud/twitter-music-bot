class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :twitter_user_id
      t.integer :tweet_id
    end
  end
end
