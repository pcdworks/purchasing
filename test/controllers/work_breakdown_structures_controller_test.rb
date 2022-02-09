require "test_helper"

class WorkBreakdownStructuresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @work_breakdown_structure = work_breakdown_structures(:one)
  end

  test "should get index" do
    get work_breakdown_structures_url
    assert_response :success
  end

  test "should get new" do
    get new_work_breakdown_structure_url
    assert_response :success
  end

  test "should create work_breakdown_structure" do
    assert_difference('WorkBreakdownStructure.count') do
      post work_breakdown_structures_url, params: { work_breakdown_structure: { title: @work_breakdown_structure.title } }
    end

    assert_redirected_to work_breakdown_structure_url(WorkBreakdownStructure.last)
  end

  test "should show work_breakdown_structure" do
    get work_breakdown_structure_url(@work_breakdown_structure)
    assert_response :success
  end

  test "should get edit" do
    get edit_work_breakdown_structure_url(@work_breakdown_structure)
    assert_response :success
  end

  test "should update work_breakdown_structure" do
    patch work_breakdown_structure_url(@work_breakdown_structure), params: { work_breakdown_structure: { title: @work_breakdown_structure.title } }
    assert_redirected_to work_breakdown_structure_url(@work_breakdown_structure)
  end

  test "should destroy work_breakdown_structure" do
    assert_difference('WorkBreakdownStructure.count', -1) do
      delete work_breakdown_structure_url(@work_breakdown_structure)
    end

    assert_redirected_to work_breakdown_structures_url
  end
end
