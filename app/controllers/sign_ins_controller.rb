class SignInsController < ApplicationController

  before_action :set_sign_in, only: [:show, :edit, :update, :destroy]


  # GET /sign_ins
  def index

    get_filter

    @sign_ins = SignIn.filter(@filter)
    @sign_ins = @sign_ins.page params[:page]

    @rooms = SignIn.uniq.pluck(:room).sort

    session[:filter_sign_ins] = @filter

  end


  # GET /sign_ins/clear_filter
  def clear_filter
    session.delete(:filter_sign_ins)
    redirect_to sign_ins_index_url
  end


  # GET /sign_ins/import
  def import
    @file_upload = FileUpload.new
  end


  # POST /sign_ins/import
  def do_import
    
    @file_upload = FileUpload.new(params[:file_upload])

    if @file_upload.valid?

      uploaded_io = params[:file_upload][:filename]

      filename = @file_upload.upload_file(uploaded_io)

      SignIn.import(filename)

      redirect_to( { action: 'index' }, notice: 'Import completed successfully.')

    else
      render 'import'
    end

  end
  


private

    def set_sign_in
      @sign_in = SignIn.find(params[:id])
    end


    def get_filter
      @filter = 
        params.slice(
          :with_first_name, 
          :with_last_name,
          :is_newcomer,
          :in_room,
          :on_or_after,
          :on_or_before,
          :order_by
        )

      @filter = session[:filter_sign_ins].symbolize_keys! if @filter.empty? && session.key?(:filter_sign_ins)

      @filter = { :order_by => 'sign_in_time desc' } if @filter.empty?

      @filter.delete_if { |key, value| value.blank? }

      @filter[:on_or_after]  = DateTime.parse(@filter[:on_or_after])  if @filter.key?(:on_or_after)
      @filter[:on_or_before] = DateTime.parse(@filter[:on_or_before]) if @filter.key?(:on_or_before)
    end


    # Parameter white list
    def sign_in_params
      params
        .require(:sign_in)
        .permit(
          :first_name,
          :last_name,
          :room,
          :sign_in_time,
          :newcomer,
          :label,
        )
    end

end
