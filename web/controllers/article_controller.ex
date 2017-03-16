defmodule Core.ArticleController do
  use Core.Web, :controller

  alias Core.Article

  plug Guardian.Plug.EnsureAuthenticated, %{handler: Core.Auth} when action in [:create, :update, :delete]
  plug Core.BodyParams, name: "article"
  plug :find when action in [:update, :delete, :show]

  def index(conn, _params) do
    articles = Repo.all(Article)
    render(conn, "index.json", articles: articles)
  end

  def create(conn, %{"article" => article_params}) do
    changeset = Article.changeset(%Article{}, article_params)

    case Repo.insert(changeset) do
      {:ok, article} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", article_path(conn, :show, article))
        |> render("show.json", article: article)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => _}) do
    article = conn.assigns[:article]
    render(conn, "show.json", article: article)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = conn.assigns[:article]
    changeset = Article.changeset(article, article_params)

    case Repo.update(changeset) do
      {:ok, article} ->
        render(conn, "show.json", article: article)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    article = conn.assigns[:article]

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(article)

    send_resp(conn, :no_content, "")
  end


  defp find(conn = %Plug.Conn{params: %{"id" => id}}, _opts) do
    case Repo.get(Article, id) do
      {:ok, article} ->
        conn
        |> assign(:article, article)

      _ ->
        conn
        |> put_status(:not_found)
        |> render(Core.ErrorView, "404.json", %{})
        |> halt()
    end
  end
end
