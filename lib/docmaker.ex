defmodule Docmaker do
  def render_file(target_path, rendered) do
    safe = Phoenix.HTML.Safe.to_iodata(rendered)
    File.write!(target_path, safe)
  end
end
