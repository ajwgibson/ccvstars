class JsonController < ApplicationController

  # GET /json/children
  def children

    names = [] unless params.has_key?(:name)
    names = params[:name].split(' ') if params.has_key?(:name)

    @children = Child.with_name(names[0]) unless names.count > 1
    @children = Child.with_first_name(names[0]).with_last_name(names[1]) if names.count > 1

    @children.order!(:first_name, :last_name)

    respond_to do |format|
      format.any {
        render json: @children,
        only: [:id],
        methods: [:full_name],
        content_type: 'application/json'
      }
    end

  end

end
