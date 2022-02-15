require "test_helper"

class RequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @request = requests(:one)
  end

  test "should get index" do
    get requests_url
    assert_response :success
  end

  test "should get new" do
    get new_request_url
    assert_response :success
  end

  test "should create request" do
    assert_difference('Request.count') do
      post requests_url, params: { request: { account_id: @request.account_id, approved_by_id: @request.approved_by_id, date_ordered: @request.date_ordered, date_received: @request.date_received, date_approved: @request.date_approved, import_tax: @request.import_tax, notes: @request.notes, order_number: @request.order_number, payment_method_id: @request.payment_method_id, project_id: @request.project_id, reason_for_rejection: @request.reason_for_rejection, requested_for_id: @request.requested_for_id, sales_tax: @request.sales_tax, shipping_charges_paid_to: @request.shipping_charges_paid_to, shipping_cost: @request.shipping_cost, status: @request.status, vendor: @request.vendor, work_breakdown_structure_id: @request.work_breakdown_structure_id } }
    end

    assert_redirected_to request_url(Request.last)
  end

  test "should show request" do
    get request_url(@request)
    assert_response :success
  end

  test "should get edit" do
    get edit_request_url(@request)
    assert_response :success
  end

  test "should update request" do
    patch request_url(@request), params: { request: { account_id: @request.account_id, approved_by_id: @request.approved_by_id, date_ordered: @request.date_ordered, date_received: @request.date_received, date_approved: @request.date_approved, import_tax: @request.import_tax, notes: @request.notes, order_number: @request.order_number, payment_method_id: @request.payment_method_id, project_id: @request.project_id, reason_for_rejection: @request.reason_for_rejection, requested_for_id: @request.requested_for_id, sales_tax: @request.sales_tax, shipping_charges_paid_to: @request.shipping_charges_paid_to, shipping_cost: @request.shipping_cost, status: @request.status, vendor: @request.vendor, work_breakdown_structure_id: @request.work_breakdown_structure_id } }
    assert_redirected_to request_url(@request)
  end

  test "should destroy request" do
    assert_difference('Request.count', -1) do
      delete request_url(@request)
    end

    assert_redirected_to requests_url
  end
end
