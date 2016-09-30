class <%= config[:name].to_s.to_camel_case.pluralize %>Migration < Peictt::Migrations
  def change
    create_table :<%= config[:name].to_snake_case.pluralize %> do |t|
      t.integer :id, null: false, primary_key: true, auto_increment: true

      t.timestamps
    end
  end

  def down
    drop :<%= config[:name].to_snake_case.pluralize %>
  end
end
