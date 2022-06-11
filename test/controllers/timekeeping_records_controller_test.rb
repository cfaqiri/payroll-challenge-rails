require "test_helper"

class TimekeepingRecordsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get timekeeping_records_index_url
    assert_response :success
  end
end
