defmodule UploadImageToS3.Files.UploadFile do
  alias UploadImageToS3.Files
  alias UploadImageToS3.Repo

  require Logger

  def call(byte_content, filename, content_type) do
    # Log the inputs when the function is called
    Logger.info("Calling with filename: #{filename}, content_type: #{content_type}")

    resource_path =
      "/files/#{Ecto.UUID.generate()}.#{case content_type do
        :jpeg -> "jpg"
        :jpg -> "jpg"
        :png -> "png"
      end}"

    # Log the generated resource path
    Logger.info("Generated resource_path: #{resource_path}")

    Repo.transaction(fn ->
      with {:ok, file} <- create_file(resource_path, filename, content_type) do
        # Log after successfully creating the file in the database
        Logger.info("File created in database with ID: #{file.id}")

        case upload(file, byte_content) do
          {:ok, _result} ->
            Logger.info("File successfully uploaded to S3")
            {:ok, file}

          error ->
            # Log any error during the upload process
            Logger.error("Error uploading to S3: #{inspect(error)}")
            error
        end
      else
        error ->
          # Log any error during the file creation process
          Logger.error("Error creating file in database: #{inspect(error)}")
          {:error, error}
      end
    end)
  end

  defp create_file(resource_path, filename, content_type) do
    result =
      Files.create_file(%{
        resource_path: resource_path,
        filename: filename,
        content_type: content_type
      })

    result
  end

  defp upload(file, content) do
    get_bucket()
    |> ExAws.S3.put_object(file.resource_path, content, opts: [content_type: file.content_type])
    |> ExAws.request(region: get_region())
  end

  defp get_bucket(), do: System.get_env("AWS_FILE_BUCKET")
  defp get_region(), do: System.get_env("AWS_FILE_BUCKET_REGION")
end
