module RequestsHelper


    def statuses
        {
            0 => 'Draft',
            1 => 'Submitted - Awaiting Approval',
            2 => 'Approved',
            3 => 'On Hold',
            4 => 'Ordered',
            5 => 'Received - Completed',
            6 => 'Received - Partial',
            7 => 'Received - Returned'
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
