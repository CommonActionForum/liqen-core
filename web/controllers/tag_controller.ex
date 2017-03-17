defmodule Core.TagController do
  use Core.Web, :controller
  alias Core.Tag

  plug Guardian.Plug.EnsureAuthenticated, %{handler: Core.Auth} when action in [:create, :update, :delete]
  plug Core.BodyParams, name: "tag"
  plug :find when action in [:update, :delete, :show]

  def index(conn, _params) do
    tags = Repo.all(Tag)
    render(conn, "index.json", tags: tags)
  end

  def create(conn, %{"tag" => tag_params}) do
    changeset = Tag.changeset(%Tag{}, tag_params)

    case Repo.insert(changeset) do
      {:ok, tag} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", tag_path(conn, :show, tag))
        |> render("show.json", tag: tag)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => _}) do
    tag = conn.assigns[:tag]
    render(conn, "show.json", tag: tag)
  end

  def update(conn, %{"id" => _, "tag" => tag_params}) do
    tag = conn.assigns[:tag]
    changeset = Tag.changeset(tag, tag_params)

    case Repo.update(changeset) do
      {:ok, tag} ->
        render(conn, "show.json", tag: tag)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => _}) do
    tag = conn.assigns[:tag]

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(tag)

    send_resp(conn, :no_content, "")
  end

  defp find(conn = %Plug.Conn{params: %{"id" => id}}, _opts) do
    case Repo.get(Tag, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(Core.ErrorView, "404.json", %{})
        |> halt()
      tag ->
        conn
        |> assign(:tag, tag)
    end
  end
end
