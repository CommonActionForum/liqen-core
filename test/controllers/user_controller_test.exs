defmodule UserControllerTest do
  use Core.ConnCase

  test "Perform the action", %{conn: conn} do
    conn = post(conn, user_path(conn, :create, %{"email" => "john@example.com",
                                                 "password"=> "12345"}))

    assert json_response(conn, 201)
  end
end
