class CategoriesController < ApplicationController
  def show
    @category = params[:category]

    unless Post.categories.key?(@category)
      redirect_to root_path, alert: "Нет такой категории"
      return
    end

    @sort = Post::SORTS.key?(params[:sort]) ? params[:sort] : "newest"
    @pagy, @posts = pagy(
      :offset,
      Post.public_send(@category).sorted_by(@sort).with_attached_image,
      limit: 10
    )
  end
end
