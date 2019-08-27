require "application_system_test_case"

class PhotosTest < ApplicationSystemTestCase

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

  test "/photos/[ID] - automatically populates photo_id and fan_id with current photo and signed in user" do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.likes_count = 0
    photo.save

    visit("/sign_in")

    within(:css, "form") do
      fill_in "Username", with: first_user.username
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end

    old_likes_count = photo.likes_count
    visit("/photos/#{photo.id}")

    click_on("Like")

    assert_not_equal(
      photo.likes.count, old_likes_count,
      "Should be able to create Like without entering `fan_id` and `photo_id`",
      )
  end

  test "/photos/[ID] - Should only display \"Unlike\" when the signed in user has liked the photo" do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.likes_count = 1
    photo.save

    like = Like.new
    like.fan_id = first_user.id
    like.photo_id = photo.id
    like.save

    visit "/sign_in"

    within(:css, "form") do
      fill_in "Username", with: first_user.username
      fill_in "Password", with: first_user.password
      click_on "Sign in"
    end

    visit "/photos/#{photo.id}"
    old_likes_count = photo.likes_count

    click_on "Unlike"

    assert_not_equal(
      photo.likes.count, old_likes_count,
      "Should only display \"Unlike\" when the signed in user has liked the photo",
    )
  end

  test "/photos/[ID] - automatically associates comment with signed in user and current photo" do
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

    test_comment = "Hey, what a nice app you're building!"

    visit "/photos/#{photo.id}"

    fill_in "Comment", with: test_comment

    click_on "Add comment"

    added_comment = Comment.where({
      :author_id => first_user.id,
      :photo_id => photo.id,
      :body => test_comment
    }).at(0)

    assert_not_nil(
      added_comment,
      "User should only need to enter a comment body and click 'Add Comment' to create and save comment record",
    )
  end

end
