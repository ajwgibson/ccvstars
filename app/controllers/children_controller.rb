class ChildrenController < ApplicationController

  before_action :set_child, only: [:show, :edit, :update, :destroy]

  # GET /children
  def index

    @filter = 
      params.slice(
        :with_first_name, 
        :with_last_name,
        :with_ministry_tracker_id,
        :with_update_required,
        :with_medical_information,
        :with_age,
      )

    @filter = session[:filter_children] if @filter.empty? && session.key?(:filter_children)

    @children = Child.filter(@filter)
    @children = @children.order('last_name', 'first_name')
    @children = @children.page params[:page]

    session[:filter_children] = @filter
  end


  # GET /children/clear_filter
  def clear_filter
    session.delete(:filter_children)
    redirect_to children_url
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
