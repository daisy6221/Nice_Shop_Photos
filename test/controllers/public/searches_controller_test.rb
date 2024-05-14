require "test_helper"

class Public::SearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get public_searches_search_url
    assert_response :success
  end
end
