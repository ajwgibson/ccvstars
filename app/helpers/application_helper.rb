module ApplicationHelper


  def is_active_controller(controller_name)
    params[:controller] == controller_name ? "active" : nil
  end


  def is_active_action(action_name)
    params[:action] == action_name ? "active" : nil
  end


  def sortable(column, filter, path, title=nil)

    title ||= column.titleize

    current_order_by = filter.fetch(:order_by, "")

    is_current = (column == current_order_by.gsub(" desc", ""))
    is_descending = current_order_by.include?("desc")

    filter = filter.except(:order_by)

    filter[:order_by] = column
    filter[:order_by] = (column.split(',').map { |x| x + " desc" }).join(",") if is_current && !is_descending

    css_class = "fa fa-sort-amount"
    css_class += "-asc" if is_current && !is_descending
    css_class += "-desc" if is_current && is_descending

    href = "#{path}?#{filter.to_query}"

    content_tag :a, :href => href  do
      concat("#{title} ")
      concat(content_tag :i, " ", :class => css_class)
    end

  end


  def check_icon(value)
      content_tag(:span, " ", class: ["fa", "fa-check-square-o"]) if value
  end


  def late_icon(value)
      content_tag(:span, " ", class: ["text-warning", "fa", "fa-bell"]) if value
  end


  #
  # Toastr messages used for application flashes
  #

  ALERT_TYPES = [:success, :info, :warning, :danger] unless const_defined?(:ALERT_TYPES)

  def toastr_flash(options = {})

    flash_messages = []

    flash.each do |type, message|

      next if message.blank?

      type = type.to_sym
      type = :success if type == :notice
      type = :info    if type == :alert
      type = :danger  if type == :error
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div, msg, "data-toastr-type" => type, :class => "toastr-message hidden")
        flash_messages << text if msg
      end
    end

    flash_messages.join("\n").html_safe
  end




end
