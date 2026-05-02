module ApplicationHelper
  def status_badge(status)
    content_tag :span, status&.humanize, class: "badge badge-#{status}"
  end

  def role_badge(role)
    content_tag :span, role&.capitalize, class: "badge role-#{role}"
  end

  def data_type_badge(data_type)
    content_tag :span, data_type, class: "badge badge-dtype"
  end
end
