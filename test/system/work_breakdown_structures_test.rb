require "application_system_test_case"

class WorkBreakdownStructuresTest < ApplicationSystemTestCase
  setup do
    @work_breakdown_structure = work_breakdown_structures(:one)
  end

  test "visiting the index" do
    visit work_breakdown_structures_url
    assert_selector "h1", text: "Work Breakdown Structures"
  end

  test "creating a Work breakdown structure" do
    visit work_breakdown_structures_url
    click_on "New Work Breakdown Structure"

    fill_in "Title", with: @work_breakdown_structure.title
    click_on "Create Work breakdown structure"

    assert_text "Work breakdown structure was successfully created"
    click_on "Back"
  end

  test "updating a Work breakdown structure" do
    visit work_breakdown_structures_url
    click_on "Edit", match: :first

    fill_in "Title", with: @work_breakdown_structure.title
    click_on "Update Work breakdown structure"

    assert_text "Work breakdown structure was successfully updated"
    click_on "Back"
  end

  test "destroying a Work breakdown structure" do
    visit work_breakdown_structures_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Work breakdown structure was successfully destroyed"
  end
end
