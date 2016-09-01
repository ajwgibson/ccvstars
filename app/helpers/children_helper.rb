module ChildrenHelper

  def date_of_birth(child)
    if (child.date_of_birth?) then
      content_tag(:span, :class => 'date-of-birth') do |variable|
        l(child.date_of_birth, :format => :short)
      end
    end
  end

  
  def sortable(column, filter, title=nil)

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

    content_tag :a, :href => children_path(filter) do
      concat("#{title} ")
      concat(content_tag :i, " ", :class => css_class)
    end 

  end

end
