class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :thumbnail
      t.string :key
      t.string :description
      t.integer :release_year
      t.timestamps
    end
  end
end
