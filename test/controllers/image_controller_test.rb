require 'test_helper'

class ImageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get image_index_url
    assert_response :success
  end

  test "should get store" do
    get image_store_url
    assert_response :success
  end

end
