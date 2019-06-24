require 'test_helper'

class TutorsEditTest < ActionDispatch::IntegrationTest
  def setup
    @tutor = tutors(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@tutor)
    get edit_tutor_path(@tutor)
    assert_template 'tutors/edit'
    patch tutor_path(@tutor), params: { tutor: { name:  "",
                                                 email: "foo@invalid",
                                                 password:              "foo",
                                                 password_confirmation: "bar" } }

    assert_template 'tutors/edit'
    assert_select "div.alert", "The form contains 4 errors."
  end

  test "successful edit with friendly forwarding" do
    get edit_tutor_path(@tutor)
    log_in_as(@tutor)
    assert_redirected_to edit_tutor_url(@tutor)
  end

  test "successful edit" do
    log_in_as @tutor
    get edit_tutor_path(@tutor)
    assert_template 'tutors/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch tutor_path(@tutor), params: { tutor: { name:  name,
                                                 email: email,
                                                 password:              "",
                                                 password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to edit_tutor_path(@tutor)
    @tutor.reload
    assert_equal name,  @tutor.name
    assert_equal email, @tutor.email
  end
end
