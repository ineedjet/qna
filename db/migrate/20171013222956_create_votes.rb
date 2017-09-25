class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :vote_type
      t.references :user
      t.references :votable, polymorphic: true

      t.timestamps
    end
  end
end
