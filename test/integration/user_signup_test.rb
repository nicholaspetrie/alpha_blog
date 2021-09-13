require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest
  def setup

  end

  test "get new user form, create user, and log in" do
    get '/signup'
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: "TestUser", email: "testuser@test.com", password: "password", admin: false } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "Welcome", response.body
    assert_match "Log out", response.body
    assert_select 'div.alert-success'
  end

  test "get new user form and reject invalid user submission" do
    get '/signup'
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "", email: "testuser@test.com", password: "passsword", admin: false } }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end
end
