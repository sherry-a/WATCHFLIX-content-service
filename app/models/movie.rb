class Movie < ApplicationRecord
    validates :title, presence: true
    validates :description, presence: true
    validates :release_year, presence: true, numericality: { only_integer: true }
end
