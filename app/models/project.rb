class Project < ApplicationRecord
    validates :title, presence: true, allow_blank: false
    validates :identifier, presence: true, allow_blank: false

    def to_s
        if self.identifier.to_i == 0
            self.title
        else
            ("%06d" % self.identifier) + '-' + self.title
        end
    end
end
