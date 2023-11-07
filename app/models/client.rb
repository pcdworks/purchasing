class Client < ApplicationRecord
    before_save :clean_up
    validates :title, presence: true, allow_blank: false
    has_many :projects


    def clean_up
        self.title = self.title.strip.gsub(' ', '_')
    end

    def to_s
        self.title
    end
end
