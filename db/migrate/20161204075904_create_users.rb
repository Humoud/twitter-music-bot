class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :handle
      t.integer :twitter_user_id, :limit => 8
      t.integer :tweet_id, :limit => 8
    end
  end
end
