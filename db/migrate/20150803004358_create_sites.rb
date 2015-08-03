class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :slug
      t.string :name
    end

    add_index :sites, :slug

    execute <<-SQL
      INSERT INTO sites (slug, name)
      VALUES ('www', 'The Greens Golf Course')
    SQL

    add_column :reservations, :site_id, :integer
    add_index :reservations, :site_id

    execute <<-SQL
      UPDATE reservations
      SET site_id = sites.id
      FROM sites
      WHERE slug = 'www'
    SQL
  end
end
