Hanami::Model.migration do
  change do
    create_table :word_tests do
      primary_key :id
      foreign_key :word_id, :words, on_delete: :cascade, null: false

      column :result, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
