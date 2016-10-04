
class ChildUploadsController < ApplicationController

  before_action :set_upload, only: [:show, :edit, :update, :destroy]


  # GET /child_uploads
  def index
    @filter = { }
    @uploads = ChildUpload.all.order(created_at: :desc).page params[:page]
  end


  # GET /child_uploads/new
  def new
    @upload = ChildUpload.new
    @heading = "New upload"
    render :form
  end


  # POST /child_uploads
  def create

    uploaded_io = params[:child_upload][:filename] if params.has_key?(:child_upload)

    @upload = ChildUpload.new(status: 'New', started_at: DateTime.now)
    @upload.filename = uploaded_io.original_filename unless uploaded_io.blank?

    if @upload.save
      @upload.process uploaded_io
      redirect_to @upload, notice: 'Upload was created successfully.'
    else
      @heading = "New upload"
      render :form
    end

  end


private

    # Use callbacks to share common setup or constraints between actions.
    def set_upload
      @upload = ChildUpload.find(params[:id])
    end

end
