json.extract! request, :id, :notes, :reason_for_rejection, :shipping_cost, :sales_tax, :import_tax, :date_received, :date_shipped, :date_ordered, :order_number, :status, :approved_by_id, :work_breakdown_structure_id, :project_id, :payment_method_id, :account_id, :requested_by_id, :shipping_charges_paid_to, :vendor, :created_at, :updated_at
json.url request_url(request, format: :json)
