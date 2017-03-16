defmodule Core.BodyParams do
  @moduledoc """
  This is a Plug for separating Body Parameters and Query Parameters.

  ```
  plug Core.BodyParams, name: "article"
  ```

  Given a `name`, creates a parameter called `name` which value is the
  body params object.
  """

  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :name)
  end

  def call(conn, name) do
    params = Map.put_new(conn.params, name, conn.body_params)
    Map.put(conn, :params, params)
  end
end
