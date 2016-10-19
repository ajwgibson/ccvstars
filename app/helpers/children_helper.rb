module ChildrenHelper

  def date_of_birth(child)
    if (child.date_of_birth?) then
      content_tag(:span, :class => 'date-of-birth') do |variable|
        l(child.date_of_birth, :format => :short)
      end
    end
  end

end
