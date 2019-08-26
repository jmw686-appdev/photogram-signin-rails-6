require "application_system_test_case"

class PhotosTest < ApplicationSystemTestCase
  test "visiting the index" do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.save

    visit("/sign_in")

    within(:css, "form") do
      fill_in "Username", with: first_user.username
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end
    visit("/photos")

    assert_selector "h1", text: "Photos"
  end

  test "/photos/[ID] - displays Update photo form when photo belongs to current user" do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.save

    visit("/sign_in")

    within(:css, "form") do
      fill_in "Username", with: first_user.username
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end

    visit("/photos/#{photo.id}")

    assert_text("Update photo")

  end

  test "/photos/[ID] - displays \"Delete this photo button\" when photo belongs to current user" do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.save

    visit("/sign_in")


    within(:css, "form") do
      fill_in "Username", with: first_user.username
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end

    visit "/photos/#{photo.id}"

    assert_text(first_user.username)

    assert_selector("a", text: "Delete this photo")

  end
end
