# frozen_string_literal: true
class CreatePostFoldingStatus < ActiveRecord::Migration[7.1]
  def change
    create_table :discourse_post_folding_post_folding_statuses do |t|
      t.integer :post_id
      t.integer :user_id
      t.timestamps
    end

    add_index :discourse_post_folding_post_folding_statuses, :post_id
  end
end
