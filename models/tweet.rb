class Tweet < ActiveRecord::Base
  has_many :users
end
