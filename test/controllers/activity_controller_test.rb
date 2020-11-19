require 'test_helper'

class ActivityControllerTest < ActionDispatch::IntegrationTest
  test "should get mine" do
    get activity_mine_url
    assert_response :success
  end

  test "should get feed" do
    get activity_feed_url
    assert_response :success
  end

end
