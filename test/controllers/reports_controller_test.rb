require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get by_payment_method" do
    get reports_by_payment_method_url
    assert_response :success
  end

  test "should get itemized_requests" do
    get reports_itemized_requests_url
    assert_response :success
  end

  test "should get summarized_requests" do
    get reports_summarized_requests_url
    assert_response :success
  end

  test "should get by_payment_method_results" do
    get reports_by_payment_method_results_url
    assert_response :success
  end

  test "should get itemized_requests_results" do
    get reports_itemized_requests_results_url
    assert_response :success
  end

  test "should get summarized_requests_results" do
    get reports_summarized_requests_results_url
    assert_response :success
  end
end
