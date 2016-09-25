class <%= config[:name].to_s.to_camel_case %>  < Peictt::Migrations
  def change
    create_table :<%= config[:name].to_snake_case %> do |t|
      t.integer :id, null: false, primary_key: true, auto_increment: true
    end
  end

  def down
    drop :<%= config[:name].to_snake_case %>
  end
end
