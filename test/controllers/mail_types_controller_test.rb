require 'test_helper'

class MailTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mail_type = mail_types(:one)
  end

  test "should get index" do
    get mail_types_url
    assert_response :success
  end

  test "should get new" do
    get new_mail_type_url
    assert_response :success
  end

  test "should create mail_type" do
    assert_difference('MailType.count') do
      post mail_types_url, params: { mail_type: { description: @mail_type.description, name: @mail_type.name, schedule: @mail_type.schedule } }
    end

    assert_redirected_to mail_type_url(MailType.last)
  end

  test "should show mail_type" do
    get mail_type_url(@mail_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_mail_type_url(@mail_type)
    assert_response :success
  end

  test "should update mail_type" do
    patch mail_type_url(@mail_type), params: { mail_type: { description: @mail_type.description, name: @mail_type.name, schedule: @mail_type.schedule } }
    assert_redirected_to mail_type_url(@mail_type)
  end

  test "should destroy mail_type" do
    assert_difference('MailType.count', -1) do
      delete mail_type_url(@mail_type)
    end

    assert_redirected_to mail_types_url
  end
end
