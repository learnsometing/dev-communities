require 'test_helper'

class SkillListInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:confirmed_user_with_location_and_skills)
  end

  test 'skill list interface for new user' do
    @user.update(skill_list: [])
    @user.reload
    sign_in @user
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

  test 'skill list interface for user with skills' do
    sign_in @user
    get edit_skill_list_path(@user.id)
    assert_select 'div.tag', count: @user.skills.count
  end

end
