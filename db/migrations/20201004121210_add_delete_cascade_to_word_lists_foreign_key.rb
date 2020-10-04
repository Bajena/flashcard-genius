Hanami::Model.migration do
  change do
    transaction do
      execute 'ALTER TABLE words DROP CONSTRAINT words_word_list_id_fkey'
      alter_table :words do
        add_foreign_key([:word_list_id], :word_lists, on_delete: :cascade, null: false)
      end
    end
  end
end
