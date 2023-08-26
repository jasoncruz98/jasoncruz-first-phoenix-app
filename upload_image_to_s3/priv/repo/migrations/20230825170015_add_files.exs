defmodule UploadImageToS3.Repo.Migrations.AddFiles do
  use Ecto.Migration

  def change do
    # Enable the uuid-ossp extension
    execute("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";")

    create table(:files) do
      add(:slug, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"))
      add(:resource_path, :string)
      add(:filename, :string)
      add(:content_type, :string)
      timestamps()
    end

    # Add indexes if you anticipate querying by these fields frequently
    create(index(:files, [:slug]))
    create(index(:files, [:resource_path]))
  end
end
