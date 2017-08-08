defmodule Core.CMS do
  @moduledoc """
  Content Management System module.

  Provides functions to manage content of the system. Content is independent
  from the other parts of the Core application.

  Use the functions `list_entries/1` and `get_entry/1` to read the stored
  content.

  To write content, use one of the following functions:

  - `add_text_link/2` to store a link referencing to an article written in HTML
  - (Coming soon) `add_text/2` to store a text article
  - (Coming soon) `add_image/2` to store an image
  - (Coming soon) `add_video/2` to store a video

  All "write" functions return an entry object
  """

  @doc """
  Retrieve all entries inside the CMS
  """
  def list_entries do
  end

  @doc """
  Get a single entry giving its ID
  """
  def get_entry(id) do
  end

  @doc """
  Add a link as an entry. The link should point to an HTML
  """
  def add_text_link(author, params) do
  end
end
