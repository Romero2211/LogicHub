class MakeLikesPolymorphic < ActiveRecord::Migration[8.1]
  def up
    add_column :likes, :likeable_type, :string
    add_column :likes, :likeable_id, :integer

    execute "UPDATE likes SET likeable_type = 'Post', likeable_id = post_id"

    change_column_null :likes, :likeable_type, false
    change_column_null :likes, :likeable_id, false

    if index_exists?(:likes, [:user_id, :post_id])
      remove_index :likes, column: [:user_id, :post_id]
    end
    remove_foreign_key :likes, :posts if foreign_key_exists?(:likes, :posts)
    remove_index :likes, :post_id if index_exists?(:likes, :post_id)
    remove_column :likes, :post_id

    add_index :likes, [:likeable_type, :likeable_id]
    add_index :likes, [:user_id, :likeable_type, :likeable_id],
              unique: true, name: "index_likes_uniqueness"
  end

  def down
    add_reference :likes, :post, foreign_key: true
    execute "UPDATE likes SET post_id = likeable_id WHERE likeable_type = 'Post'"
    execute "DELETE FROM likes WHERE likeable_type != 'Post'"

    remove_index :likes, name: "index_likes_uniqueness" if index_exists?(:likes, name: "index_likes_uniqueness")
    remove_index :likes, column: [:likeable_type, :likeable_id] if index_exists?(:likes, [:likeable_type, :likeable_id])
    remove_column :likes, :likeable_type
    remove_column :likes, :likeable_id

    add_index :likes, [:user_id, :post_id], unique: true
  end
end
