Hanami::Model.migration do
  change do
    alter_table :users do
      add_column :email, String, null: false, unique: true
      add_column :password_digest, String, null: false

      add_index :email
    end
  end
end
