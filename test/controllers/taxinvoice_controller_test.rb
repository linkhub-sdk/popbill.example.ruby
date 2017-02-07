require 'test_helper'

class TaxinvoiceControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
