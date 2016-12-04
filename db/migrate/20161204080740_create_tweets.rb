class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :message
      t.boolean :replied
    end
  end
end
