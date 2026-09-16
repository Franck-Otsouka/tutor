class Service < ApplicationRecord
  belongs_to :coach_profile
  belongs_to :category
end
