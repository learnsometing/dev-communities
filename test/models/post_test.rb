# frozen_string_literal: true

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = Post.new(content: 'This is my first post.')
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
    assert_equal posts(:post_49), Post.first
  end
end
