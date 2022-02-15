require "application_system_test_case"

class RequestsTest < ApplicationSystemTestCase
  setup do
    @request = requests(:one)
  end

  test "visiting the index" do
    visit requests_url
    assert_selector "h1", text: "Requests"
  end

  test "creating a Request" do
    visit requests_url
    click_on "New Request"

    fill_in "Account", with: @request.account_id
    fill_in "Approved by", with: @request.approved_by_id
    fill_in "Date ordered", with: @request.date_ordered
    fill_in "Date received", with: @request.date_received
    fill_in "Date approved", with: @request.date_approved
    fill_in "Import tax", with: @request.import_tax
    fill_in "Notes", with: @request.notes
    fill_in "Order number", with: @request.order_number
    fill_in "Payment method", with: @request.payment_method_id
    fill_in "Project", with: @request.project_id
    fill_in "Reason for rejection", with: @request.reason_for_rejection
    fill_in "Requested by", with: @request.requested_for_id
    fill_in "Sales tax", with: @request.sales_tax
    fill_in "Shipping charges paid to", with: @request.shipping_charges_paid_to
    fill_in "Shipping cost", with: @request.shipping_cost
    fill_in "Status", with: @request.status
    fill_in "Vendor", with: @request.vendor
    fill_in "Work breakdown structure", with: @request.work_breakdown_structure_id
    click_on "Create Request"

    assert_text "Request was successfully created"
    click_on "Back"
  end

  test "updating a Request" do
    visit requests_url
    click_on "Edit", match: :first

    fill_in "Account", with: @request.account_id
    fill_in "Approved by", with: @request.approved_by_id
    fill_in "Date ordered", with: @request.date_ordered
    fill_in "Date received", with: @request.date_received
    fill_in "Date approved", with: @request.date_approved
    fill_in "Import tax", with: @request.import_tax
    fill_in "Notes", with: @request.notes
    fill_in "Order number", with: @request.order_number
    fill_in "Payment method", with: @request.payment_method_id
    fill_in "Project", with: @request.project_id
    fill_in "Reason for rejection", with: @request.reason_for_rejection
    fill_in "Requested for", with: @request.requested_for_id
    fill_in "Sales tax", with: @request.sales_tax
    fill_in "Shipping charges paid to", with: @request.shipping_charges_paid_to
    fill_in "Shipping cost", with: @request.shipping_cost
    fill_in "Status", with: @request.status
    fill_in "Vendor", with: @request.vendor
    fill_in "Work breakdown structure", with: @request.work_breakdown_structure_id
    click_on "Update Request"

    assert_text "Request was successfully updated"
    click_on "Back"
  end

  test "destroying a Request" do
    visit requests_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Request was successfully destroyed"
  end
end
