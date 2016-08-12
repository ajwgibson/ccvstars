class ChildrenController < ApplicationController

  before_action :set_child, only: [:show, :edit, :update, :destroy]

  # GET /children
  def index
    @children = Child.order('last_name', 'first_name')
  end


  # GET /children/new
  def new
    @child = Child.new
    @heading = "Add a child"
    render :form
  end


  # POST /children
  def create

    @child = Child.new(child_params)

    if @child.save
      redirect_to @child, notice: 'Child was created successfully.'
    else
      @heading = "Add a child"
      render :form
    end

  end


  # GET /children/edit
  def edit
    @heading = "Edit a child"
    render :form
  end


  # PATCH/PUT /children
  def update

    if @child.update(child_params)
      redirect_to @child, notice: 'Child was updated successfully.'
    else
      @heading = "Edit a child"
      render :form
    end

  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_child
      @child = Child.find(params[:id])
    end

    # Parameter white list
    def child_params
      params
        .require(:child)
        .permit(
          :first_name,
          :last_name,
          :date_of_birth,
          :medical_information,
          :ministry_tracker_id,
          :update_required,
        )
    end

end
