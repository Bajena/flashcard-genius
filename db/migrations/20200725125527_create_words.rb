Hanami::Model.migration do
  change do
    create_table :words do
      primary_key :id
      foreign_key :word_list_id, :word_lists, on_delete: :cascade, null: false

      column :question, String, null: false
      column :question_example, String
      column :answer, String, null: false
      column :answer_example, String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
