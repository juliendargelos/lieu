module ApplicationHelper
  def button_link_to(label, path, options = {})
    options = options.symbolize_keys
    options[:class] = [:button, options[:class]].compact.join ' '
    link_to label, path, options
  end

  def view_class
    "#{controller_name.gsub /[\/_]/, '-'}-#{action_name}"
  end

  def vue(application)
    @vue = true
    content_tag(:div, nil, data: { vue: application.to_s.classify })
  end

  def vue?
    !!@vue
  end
end
