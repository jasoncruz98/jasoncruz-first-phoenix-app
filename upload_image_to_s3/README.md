# UploadImageToS3

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

### Upload image to S3
- visit localhost:4000/upload to upload image
- click on generated links to view image in new tab
- .env.example is provided for reference
- for this repo, you need to create your own postgres database locally
- run `source .env` to set environment variables
- run `mix setup` to install dependencies, create database, and run migrations
- run `iex -S mix phx.server` to start server