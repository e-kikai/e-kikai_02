class CompaniesController < ApplicationController
  before_action :find_company, except: [:index]
  layout "company",            except: [:index]

  def index
    @companies = Company.all
  end

  def show
  end

  def detail
  end

  def map
  end

  def search
    q = [];
    @machines  = @company.machines.search_list(q)
    @names     = @company.machines.search_names(q)
    @nmachines = @machines.group_by(&:name)

    @addr1s = @machines.map(&:addr1).uniq

    @title = @company.name

    @params = {}

    render :template => "main/search"
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

    c   = Sass::Script::Color.from_hex(@company.theme_color || Company::THEME_COLORS[:cyan])
    rev = c.with(hue: ((c.hue + 180) % 360))
    @c = {
      base:        c.inspect,
      darkness:    c.with(saturation: 100, lightness: 15).inspect,
      dark:        c.with(saturation: 100, lightness: 30).inspect,
      right:       c.with(saturation: 25,  lightness: 100).inspect,
      rightness:   c.with(saturation: 10,  lightness: 100).inspect,
      rev:         rev.inspect,
      rightrev:    rev.with(saturation: 25,  lightness: 100).inspect,
      darkrev:     rev.with(saturation: 100, lightness: 30).inspect,
      darknessrev: rev.with(saturation: 100, lightness: 15).inspect,
    }
  rescue
    redirect_to "/", alert: "e-kikaiメンバ情報が取得できませんでした"
  end

  def search_params
    params.permit(:large_genre_id_eq, :middle_genre_id_eq, :genre_id_eq, :addr1_eq)
    # redirect_to root_url, status: :bad_request, alert: "検索条件がありません" if params.blank?
  rescue
    redirect_to "/#{@company.subdomain}/", status: :bad_request, alert: "検索条件が不正です"
  end

  def contact_params
    params.require(:contact).permit(:name, :mail, :content, :company_id, :officer, :tel)
  end
end
