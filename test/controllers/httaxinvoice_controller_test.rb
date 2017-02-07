require 'test_helper'

class HttaxinvoiceControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
