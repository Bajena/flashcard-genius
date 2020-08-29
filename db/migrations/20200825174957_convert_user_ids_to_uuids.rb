Hanami::Model.migration do
  up do
    execute 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'

    alter_table :word_lists do
      add_column :uid, 'uuid', null: false, default: Hanami::Model::Sql.function(:uuid_generate_v4)
    end

    alter_table :words do
      add_column :word_list_uid, 'uuid'
    end

    execute 'UPDATE words w SET word_list_uid = (SELECT uid FROM word_lists wl WHERE wl.id = w.word_list_id)'

    alter_table :words do
      drop_column(:word_list_id)
    end

    alter_table :word_lists do
      drop_column :id

      rename_column :uid, :id
      add_primary_key([:id])
    end

    alter_table :words do
      rename_column :word_list_uid, :word_list_id
      add_foreign_key([:word_list_id], :word_lists)
    end
  end
end
