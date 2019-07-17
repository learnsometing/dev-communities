# frozen_string_literal: true

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    # Create a post factory, which is already associated with a user factory
    # and contains content.
    @post = create(:post)
  end

  test 'post with content belonging to an author should be valid' do
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
    assert_equal @post, Post.first
  end
end
