class MailTypesController < ApplicationController
  before_action :set_mail_type, only: [:show, :edit, :update, :destroy]

  # GET /mail_types
  # GET /mail_types.json
  def index
    @mail_types = MailType.all
  end

  # GET /mail_types/1
  # GET /mail_types/1.json
  def show
  end

  # GET /mail_types/new
  def new
    @mail_type = MailType.new
  end

  # GET /mail_types/1/edit
  def edit
  end

  # POST /mail_types
  # POST /mail_types.json
  def create
    @mail_type = MailType.new(mail_type_params)

    respond_to do |format|
      if @mail_type.save
        format.html { redirect_to @mail_type, notice: 'Mail type was successfully created.' }
        format.json { render :show, status: :created, location: @mail_type }
      else
        format.html { render :new }
        format.json { render json: @mail_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mail_types/1
  # PATCH/PUT /mail_types/1.json
  def update
    respond_to do |format|
      if @mail_type.update(mail_type_params)
        format.html { redirect_to @mail_type, notice: 'Mail type was successfully updated.' }
        format.json { render :show, status: :ok, location: @mail_type }
      else
        format.html { render :edit }
        format.json { render json: @mail_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mail_types/1
  # DELETE /mail_types/1.json
  def destroy
    @mail_type.destroy
    respond_to do |format|
      format.html { redirect_to mail_types_url, notice: 'Mail type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mail_type
      @mail_type = MailType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mail_type_params
      params.require(:mail_type).permit(:name, :description, :schedule)
    end
end
