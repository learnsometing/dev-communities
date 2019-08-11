require 'test_helper'

class SkillListInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:confirmed_user_with_location_and_skills)
    sign_in @user
  end

  test 'skill list interface for new user' do
    @user.update(skill_list: [])
    @user.reload
    get edit_skill_list_path(@user.id)
    assert_template 'users/edit_skill_list'
    assert_select 'div#tagging-header', count: 1
    assert_select 'div#tagging-instructions', count: 1
    assert_select 'div#tag-search', count: 1
    assert_select 'input#tag-search-field', count: 1
    assert_select 'div#tags', count: 1
    assert_select 'div.tag', count: 0
    assert_select 'form#skills-form', count: 1
  end

  test 'skill list interface for user without skills' do
    @user.update(skill_list: [])
    @user.reload
    get edit_skill_list_path(@user.id)
    assert_select 'div.tag', count: @user.skills.count
    assert_select 'input#submit-skills', disabled: true
  end

  test 'skill list interface for user with skills' do
    get edit_skill_list_path(@user.id)
    assert_select 'div.tag', count: @user.skills.count
    assert_select 'input#submit-skills', disabled: false
  end

  test 'successful skill list update with initially empty skill list' do
    @user.update(skill_list: [])
    @user.reload
    assert_difference '@user.skills.count', 2 do
      patch user_path(@user.id), params: { user: { skill_list: %w[Ruby Javascript] } }
    end
    # user show view code here
  end

  test 'successful skill list update with initially populated skill list' do
    assert_difference '@user.skills.count', -3 do
      patch user_path(@user.id), params: { user: { skill_list: ['Java'] } }
    end
  end
end
