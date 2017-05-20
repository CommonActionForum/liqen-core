defmodule Core.Web.ArticleController do
  use Core.Web, :controller
  alias Core.Article

  plug :find when action in [:update, :delete, :show]
  plug Core.Auth, %{key: :article, type: "articles"}
  when action in [:create, :update, :delete]

  def index(conn, _params) do
    articles = Repo.all(Article)
    render(conn, "index.json", articles: articles)
  end

  def create(conn, article_params) do
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
        |> render(Core.Web.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, _) do
    article = conn.assigns.article
    render(conn, "show.json", article: article)
  end

  def update(conn, article_params) do
    article = conn.assigns.article
    changeset = Article.changeset(article, article_params)

    case Repo.update(changeset) do
      {:ok, article} ->
        render(conn, "show.json", article: article)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.Web.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, _) do
    article = conn.assigns.article

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(article)

    send_resp(conn, :no_content, "")
  end

  defp find(conn = %Plug.Conn{params: %{"id" => id}}, _opts) do
    case Repo.get(Article, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(Core.Web.ErrorView, "404.json", %{})
        |> halt()

      article ->
        conn
        |> assign(:article, article)
    end
  end
end
