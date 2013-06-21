module ApplicationHelper
  def cp(path)
    "class=active" if current_page?(path)
  end
end
