defmodule UploadImageToS3.Files do
  use Ecto.Schema
  import Ecto.Changeset

  alias UploadImageToS3.Repo

  schema "files" do
    field(:slug, Ecto.UUID, autogenerate: true)
    field(:resource_path, :string)
    field(:filename, :string)
    field(:content_type, Ecto.Enum, values: [:bmp, :gif, :jpeg, :jpg, :png, :tiff, :webp])
    timestamps()
  end

  def changeset(file, attrs) do
    file
    |> cast(attrs, [:filename, :resource_path, :content_type])
    |> validate_required([:filename, :resource_path, :content_type])
  end

  def list_all_files do
    Repo.all(__MODULE__)
  end

  def get_file_by_slug!(slug) do
    Repo.get_by!(__MODULE__, slug: slug)
  end

  def create_file(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end
end
