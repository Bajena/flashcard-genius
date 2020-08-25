Hanami::Model.migration do
  change do
    alter_table :word_lists do
      add_foreign_key :user_id, :users, on_delete: :cascade
    end
  end
end
