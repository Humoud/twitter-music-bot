class Tweet < ActiveRecord::Base
  has_one :user
end
