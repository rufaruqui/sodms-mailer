class EmailsController < ApplicationController
     before_action :set_email, only: [:show, :edit, :update, :destroy, :resend_email]

  # GET /emails
  # GET /emails.json
  def index
    fromDate = params[:fromDate].to_i / 1000
    toDate = params[:toDate].to_i / 1000
    
    fromDate = DateTime.strptime(fromDate.to_s,'%s')
    toDate = DateTime.strptime(toDate.to_s,'%s')
     
    @emails = Email.where(created_at:fromDate..toDate)
    options = {:payload=>{:data=>@emails.to_json}, :hmac_secret=>"thisisreallytoughy"}
    
    @summary = Hash.new
    @summary = { :created=>@emails.where(state: :created).count, 
                 :sent => @emails.where(state: :sent).count, 
                 :delivered => @emails.where(state: :delivered).count, 
                 :failed => @emails.where(state: :failed).count
                 } unless @emails.nil? or @emails.blank?
        
    @payload = EncryptionService.sign :emails=> @emails.to_json, :summary=>@summary
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
  end

  # GET /emails/new
  def new
    @email = Email.new
  end

  # GET /emails/1/edit
  def edit
  end

  # POST /emails
  # POST /emails.json
  def create
    @email = Email.new(email_params)

    respond_to do |format|
      if @email.save
        format.html { redirect_to @email, notice: 'Email was successfully created.' }
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /emails/1
  # PATCH/PUT /emails/1.json
  def update
    respond_to do |format|
      if @email.update(email_params)
        format.html { redirect_to @email, notice: 'Email was successfully updated.' }
        format.json { render :show, status: :ok, location: @email }
      else
        format.html { render :edit }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email.destroy
    respond_to do |format|
      format.html { redirect_to emails_url, notice: 'Email was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def resend_email
    sent_email [@email] 
    render json: { :message=>"email queued for delivery", status: :ok, :errors=>nil} 
  end 

  def resend_emails
    emails = Email.where(state: params[:state].downcase.to_sym) 
    sent_email emails unless emails.blank?
    render json: { :message=>"email queued for delivery", status: :ok, :errors=>nil} 
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_params
      params.require(:email).permit(:fromDate, :toDate, :subject, :body, :state, :permitteddepoid, :recipients, :attachment_name, :mail_type)
    end

    def sent_email emails
      emails.each do |email|
        options = Hash.new
        options[:recipents] = email.recipients
        options[:cc] = email.cc
        options[:filename]  = email.attachment
        options[:subject]   = email.subject
        options[:body]      = email.body
        options[:attachment_name] = email.attachment_name
        ReportMailer.daily_email_update(options).deliver
        email.update(state: :sent)
      end

    end
end
 