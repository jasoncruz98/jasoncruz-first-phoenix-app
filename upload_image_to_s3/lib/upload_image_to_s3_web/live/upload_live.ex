defmodule UploadImageToS3Web.UploadLive do
  use UploadImageToS3Web, :live_view
  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>Upload an Image</h1>
      <form id="upload-form" phx-submit="save" phx-change="validate">
        <.live_file_input upload={@uploads.image} />
        <button type="submit" phx-disable-with="Uploading...">Upload Image</button>
      </form>

      <ul>
        <li :for={file <- @files} id={"file-#{file.id}"} phx-click="show" phx-value-file_id={file.id}>
          <a href= {s3_url(file.resource_path)} target="_blank"><%= file.filename %></a>
        </li>
      </ul>

    </div>
    """
  end

  defp s3_url(resource_path) do
    # Additional query parameters for the pre-signed URL
    query_params = [
      {"response-content-disposition", "inline"},
      {"response-content-type", "image/jpeg"}
    ]

    config = ExAws.Config.new(:s3) |> Map.put(:region, System.get_env("AWS_FILE_BUCKET_REGION"))

    bucket = System.get_env("AWS_FILE_BUCKET")
    http_method = :get

    opts = [
      expires_in: 3600,
      virtual_host: true,
      query_params: query_params
    ]

    case ExAws.S3.presigned_url(config, http_method, bucket, resource_path, opts) do
      {:ok, url} ->
        Logger.info("Generated presigned URL: #{url}")
        url

      {:error, reason} ->
        Logger.error("Failed to generate presigned URL: #{reason}")
        nil
    end
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_files()
      |> assign(:current_file, nil)
      |> allow_upload(:image, accept: ~w(.jpg .jpeg .png))

    {:ok, socket}
  end

  def handle_event("validate", _params, socket), do: {:noreply, socket}

  @impl true
  def handle_event("save", _params, socket) do
    [result] =
      consume_uploaded_entries(socket, :image, fn %{path: path}, entry ->
        content = File.read!(path)
        filename = entry.client_name
        content_type = parse_content_type(entry)

        UploadImageToS3.Files.UploadFile.call(content, filename, content_type)
      end)

    case result do
      {:ok, _file} ->
        {:noreply, socket |> assign_files() |> put_flash(:info, "Upload successful!")}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Upload failed. Please try again.")}
    end
  end

  defp parse_content_type(entry) do
    case entry.client_type do
      "image/png" -> :png
      "image/jpeg" -> :jpeg
      "image/jpg" -> :jpg
    end
  end

  defp assign_files(socket) do
    # Function to list all uploaded files
    files = UploadImageToS3.Files.list_all_files()
    assign(socket, :files, files)
  end
end
