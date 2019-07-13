# frozen_string_literal: true

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = build(:post)
  end

  test 'post should belong to an author' do
    assert Post.new.invalid?
  end

  test 'post with content should be valid' do
    assert @post.valid?
  end

  test 'post should be invalid without content' do
    @post.content = nil
    assert @post.invalid?
  end

  test 'post content should be limited to 3000 characters' do
    @post.content = 'a' * 3000
    assert @post.valid?
    @post.content += 'a'
    assert @post.invalid?
  end

  test 'order should be most recent first' do
    posts = [create(:post, created_at: 5.minutes.ago),
             create(:post, created_at: 10.minutes.ago),
             create(:post, created_at: 15.minutes.ago) ]
    assert_equal posts[0], Post.first
  end
end
