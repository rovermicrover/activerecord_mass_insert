# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :dogs, force: true do |t|
    t.string   :name
    t.string   :nickname
    t.string   :breed
    t.integer  :age
    t.boolean  :rescue
    t.datetime :birthday
    t.string   :owner
    t.jsonb    :meta
    t.timestamps null: false

    t.index :name
    t.index :breed
    t.index :rescue
  end
end
