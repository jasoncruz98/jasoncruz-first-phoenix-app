defmodule UploadImageToS3.Repo do
  use Ecto.Repo,
    otp_app: :upload_image_to_s3,
    adapter: Ecto.Adapters.Postgres
end
