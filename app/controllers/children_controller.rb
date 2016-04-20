class ChildrenController < ApplicationController
  def index
    @children = Child.order('last_name', 'first_name')
  end
end
