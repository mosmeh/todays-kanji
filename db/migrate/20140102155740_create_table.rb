class CreateTable < ActiveRecord::Migration
  def up
    create_table :days do |t|
      t.date :date
      t.integer :todays_kanji
    end

    create_table :kanjis do |t|
      t.integer :kanji
      t.integer :count, default: 0
      t.decimal :score, default: 0.0

      t.integer :day_id
    end
  end

  def down
    drop_table :days
    drop_table :kanjis
  end
end
