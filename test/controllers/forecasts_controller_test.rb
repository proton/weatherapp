require 'test_helper'

class ForecastsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get forecasts_path
    assert_response :success
  end

  test "should get retrieve" do
    get retrieve_forecasts_path
    assert_response :success
  end

end
