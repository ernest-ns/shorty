class CreateUrlMappings < ActiveRecord::Migration[5.1]
  def self.up
    create_table :url_mappings do |t|
      t.string      :shortcode,             null: false
      t.text        :url,                     null: false
      t.integer :redirect_count, default: 0,       null: false
      t.datetime :start_date,          null: false
      t.datetime :last_seen_date
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :url_mappings
  end
end
