module RequestsHelper


    def statuses
        {
            0 => 'Draft',
            1 => 'Submitted and Awaiting Approval',
            2 => 'Approved',
            3 => 'On Hold',
            4 => 'Ordered',
            5 => 'Received',
            6 => 'Partially Received',
            7 => 'Received and Returned',
            8 => 'Partially Received and Partially Returned'
        }
    end

    def shipping_charges
        {
            0 => 'Vendor',
            1 => 'UPS Account',
            2 => 'FedEx Account'
        }
    end
end
