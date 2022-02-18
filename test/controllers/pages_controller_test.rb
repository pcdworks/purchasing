require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get browsers" do
    get pages_browsers_url
    assert_response :success
  end
end
