class Project < ApplicationRecord
    validates :title, presence: true, allow_blank: false
    validates :identifier, presence: true, allow_blank: false
    belongs_to :client

    def to_s
        if self.identifier.to_i == 0
            self.title
        else
            if self.client.nil?
            ("%06d" % self.identifier) + '-' + self.title
            else
                self.client.to_s + "/" + ("%06d" % self.identifier) + '-' + self.title
            end
        end
    end
end
