class ChildrenController < ApplicationController

  before_action :set_child, only: [:show, :edit, :update, :destroy]

  def index
    @children = Child.order('last_name', 'first_name')
  end

  def show
  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_child
      @child = Child.find(params[:id])
    end

end
