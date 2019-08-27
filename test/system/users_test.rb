require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "/sign_in - has a header with text 'Sign in'" do

    visit("/sign_in")
    assert_selector("h1", text: "Sign in")
  end
end
