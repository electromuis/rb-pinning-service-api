module ApplicationHelper
  include Pagy::Frontend

  def flash_class(level)
    class_type =
      case level.to_sym
      when :success then 'success'
      when :error then 'danger'
      when :warning then 'warning'
      end
    "alert alert-#{class_type}"
  end
end
