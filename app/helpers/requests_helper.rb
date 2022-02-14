module RequestsHelper


    def statuses
        {
            0 => 'Awaiting Approval',
            1 => 'Approved',
            2 => 'On Hold',
            3 => 'Ordered',
            4 => 'Received - Completed',
            5 => 'Received - Partial',
            6 => 'Received - Returned'
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
