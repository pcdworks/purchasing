class Project < ApplicationRecord
    validates :title, presence: true, allow_blank: false
    validates :identifier, presence: true, allow_blank: false

    def to_s
        self.identifier.to_s + '-' + self.title
    end
end
