defmodule UploadImageToS3Web.FileController do
  use UploadImageToS3Web, :controller

  alias UploadImageToS3.Files

  def show(conn, %{"slug" => slug}) do
    file = Files.get_file_by_slug!(slug)

    conn
    |> put_resp_header("content-type", convert_content_type(file))
    |> send_resp(200, file.resource_path)
  end

  defp convert_content_type(file) do
    case file.content_type do
      :jpeg -> "image/jpeg"
      :jpg -> "image/jpeg"
      :png -> "image/png"
      :bmp -> "image/bmp"
      :gif -> "image/gif"
      :tiff -> "image/tiff"
      :webp -> "image/webp"
    end
  end
end
