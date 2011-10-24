class Layouts::Application < Stache::View
  def stylesheets
    stylesheet_link_tag    "application"
  end

  def javascripts
    javascript_include_tag "application"
  end

  def meta_tags
    csrf_meta_tags
  end
end

