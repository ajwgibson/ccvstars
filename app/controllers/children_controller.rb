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
        :order_by
      )

    @filter = session[:filter_children].symbolize_keys! if @filter.empty? && session.key?(:filter_children)

    @filter = { :order_by => 'last_name,first_name' } if @filter.empty?

    @children = Child.filter(@filter)

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


  # DELETE /children
  def destroy
    @child.destroy
    redirect_to children_url, notice: 'Child was successfully deleted.'
  end


  # GET /children/import
  def import
    @file_upload = FileUpload.new
  end


  # POST /children/import
  def do_import
    
    @file_upload = FileUpload.new(params[:file_upload])

    if @file_upload.valid?

      uploaded_io = params[:file_upload][:filename]

      filename = @file_upload.upload_file(uploaded_io)

      Child.import(filename)

      redirect_to( { action: 'index' }, notice: 'Import completed successfully.')

    else
      render 'import'
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
