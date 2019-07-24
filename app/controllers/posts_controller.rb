# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_post, only: %i[edit update destroy]

  def create
    @post = current_user.posts.build(post_params)
    respond_to do |format|
      format.html do
        if @post.save
          flash[:success] = 'Post created.'
        else
          # Is this the conventional way to handle this with HTML only?
          @post.errors.full_messages.each do |msg|
            flash[:danger] = msg + '.'
          end
        end
        redirect_to current_user
      end
    end
  end

  def show
    if Post.exists?(params[:id])
      @post = Post.find(params[:id])
    else
      flash[:danger] = 'Post not found.'
      redirect_to root_path
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = 'Post successfully updated'
      redirect_to @post.author
    else
      render 'posts/edit'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = 'Post deleted'
    redirect_to request.referrer || current_user
  end

  def post_params
    params.require(:post).permit(:content)
  end

  def correct_post
    # Checks that the post belongs to the currently logged in user to prevent
    # a malicious user from manipulating posts that are not theirs.
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end
end
