class SignInsController < ApplicationController

  before_action :set_sign_in, only: [:show, :edit, :update, :destroy]

  before_action only: [:new, :create] do
    @heading = "Add a sign in record"
  end


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
    redirect_to sign_ins_url
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


  # GET /sign_ins/new
  def new
    @sign_in = SignIn.new
    render :form
  end

  # POST /sign_ins
  def create

    @sign_in = SignIn.new(sign_in_params)

    @sign_in.child = nil if @sign_in.newcomer?

    if !@sign_in.newcomer? && !@sign_in.child.nil?
      @sign_in.first_name = @sign_in.child.first_name
      @sign_in.last_name  = @sign_in.child.last_name
    end

    unless params[:the_date].empty? || params[:the_time].empty?
      @sign_in.sign_in_time = DateTime.parse("#{params[:the_date]} #{params[:the_time]}")
    end

    if @sign_in.save
      redirect_to( { action: 'index' }, notice: "Sign in record was created successfully.")
    else
      @the_date = params[:the_date]
      @the_time = params[:the_time]
      render :form
    end

  end

  # DELETE /sign_ins
  def destroy
    @sign_in.destroy
    redirect_to sign_ins_url, notice: 'Record was successfully deleted.'
  end

  # GET /sign_ins/edit
  def edit
    @heading = "Edit a record"
    render :form
  end

  # PATCH/PUT /sign_ins
  def update

    @sign_in.attributes = sign_in_params
    @sign_in.sign_in_time = nil
    @sign_in.child = nil if @sign_in.newcomer?

    if !@sign_in.newcomer? && !@sign_in.child.nil?
      @sign_in.first_name = @sign_in.child.first_name
      @sign_in.last_name  = @sign_in.child.last_name
    end

    unless params[:the_date].empty? || params[:the_time].empty?
      @sign_in.sign_in_time = DateTime.parse("#{params[:the_date]} #{params[:the_time]}")
    end

    if @sign_in.save
      redirect_to @sign_in, notice: 'Sign in record was updated successfully.'
    else
      @heading = "Edit a record"
      @the_date = params[:the_date]
      @the_time = params[:the_time]
      render :form
    end

  end

private

    def set_sign_in
      @sign_in = SignIn.find(params[:id])
      @the_date = @sign_in.sign_in_time.strftime("%d/%m/%Y")
      @the_time = @sign_in.sign_in_time.strftime("%H:%M:%S")
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
          :child_id,
        )
    end

end
