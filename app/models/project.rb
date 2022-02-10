class Project < ApplicationRecord
    validates :title, presence: true, allow_blank: false
    validates :identifier, presence: true, allow_blank: false
end
