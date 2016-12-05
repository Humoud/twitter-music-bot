class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :handle
      t.integer :twitter_user_id, :limit => 8 # setting limit to 8 bytes
      t.integer :tweet_id, :limit => 8 # setting limit to 8 bytes
    end
  end
end
