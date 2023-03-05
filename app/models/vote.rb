class Vote < ApplicationRecord
  belongs_to :choice
  belongs_to :user
end
