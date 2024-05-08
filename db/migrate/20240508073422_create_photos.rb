class CreatePhotos < ActiveRecord::Migration[6.1]
  def change
    create_table :photos do |t|

      t.integer :post_id, null: false
      t.string  :image, null: false
      t.timestamps
    end
  end
end
