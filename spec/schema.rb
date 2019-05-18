ActiveRecord::Schema.define do
  self.verbose = false

  create_table :dogs, :force => true do |t|
    t.string   :type
    t.string   :name
    t.string   :breed
    t.integer  :age
    t.boolean  :show
    t.datetime :birthday
    t.string   :owner
    t.jsonb    :meta
    t.timestamps null: false
  end
end