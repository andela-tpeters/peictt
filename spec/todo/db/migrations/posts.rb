class Post  < Peictt::Migrations
  def change
    create_table :posts do |t|
      t.integer :id, null: false, primary_key: true, auto_increment: true
      t.string :title
      t.varchar :body

      t.timestamps
    end
  end

  def down
    drop :post
  end
end
