class AddMissingPerformanceIndexes < ActiveRecord::Migration[8.1]
  def change
    # Головна стрічка: ORDER BY created_at DESC/ASC
    add_index :posts, :created_at, name: "index_posts_on_created_at"

    # Сторінка категорії: WHERE category = ? ORDER BY created_at ...
    # Лівий префікс (category) також покриває Post.movies / .series тощо.
    add_index :posts, [:category, :created_at], name: "index_posts_on_category_and_created_at"

    # Коментарі під постом: WHERE post_id = ? ORDER BY created_at ...
    # Лівий префікс (post_id) покриває COUNT(*) для сортування "обсуждаемые".
    add_index :comments, [:post_id, :created_at], name: "index_comments_on_post_id_and_created_at"
  end
end
