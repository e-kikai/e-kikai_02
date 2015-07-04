class CompaniesController < ApplicationController
  before_action :find_company, except: [:index]
  layout "company",            except: [:index]

  def index
    @companies = Company.all
  end

  def show
  end

  def contact
    @contact = Contact.new(company_id: @company.id)
  end

  def contact_create
    @contact = Contact.new(contact_params)

    begin
      Contact.transaction do
        @contact.save!

        ContactMailer.company_contact(@contact, @company).deliver
        ContactMailer.company_contact_confirm(@contact, @company).deliver
      end

      redirect_to "/#{@company.subdomain}/contact_fin", notice: '問い合わせを送信しました'
    rescue => e
      flash.now[:alert] = e.message
      render :action => :contact
    end
  end

  def contact_fin
  end

  private

  def find_company
    @company = Company.find_by(subdomain: params[:subdomain])
  rescue
    redirect_to root_path, alert: "e-kikaiメンバ情報が取得できませんでした"
  end

  def contact_params
    params.require(:contact).permit(:name, :mail, :content, :company_id, :officer, :tel)
  end
end
