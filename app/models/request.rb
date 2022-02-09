class Request < ApplicationRecord
  belongs_to :approved_by, class_name: "Account", optional: true
  belongs_to :work_breakdown_structure
  belongs_to :project
  belongs_to :payment_method
  belongs_to :account
  belongs_to :requested_by, class_name: "Account"

  has_many :items, dependent: :destroy

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true
end
