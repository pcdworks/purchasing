class Project < ApplicationRecord
    validates :title, presence: true, allow_blank: false
    validates :identifier, presence: true, allow_blank: false, uniqueness: true
    belongs_to :client
    before_save :clean_up


    def clean_up
        self.title = self.title.strip.gsub(' ', '_')
    end

    def to_s
        if self.identifier.to_i == 0
            if self.client.nil?
                self.title
            else
                self.client.to_s + "/" + self.title
            end
        else
            if self.client.nil?
            ("%06d" % self.identifier) + '-' + self.title
            else
                self.client.to_s + "/" + ("%06d" % self.identifier) + '-' + self.title
            end
        end
    end
end
