class MainController < ApplicationController
  ### トップページ ###
  def index
    @genres = LargeGenre.all.order('order_no ASC')
  end

  ### 検索結果一覧 ###
  def search
    @machines = Machine.search_list(search_params)
  end

  ### 機械詳細 ###
  def machine
    @machine = Machine.find(params[:id])

    @machines = Machine.search_list(middle_genre_id_eq: @machine.genre.middle_genre.id)
  end

  ### 機械問い合わせ ###
  def contact
    @machine = Machine.find(params[:id])
    @contact = Contact.new(machine_id: @machine.id, company_id: @machine.company_id)
  end

  def contact_create
    @contact = Contact.new(contact_params)

    begin
      Contact.transaction do
        @contact.save!

        ContactMailer.contact(@contact).deliver
        ContactMailer.contact_confirm(@contact).deliver
      end

      redirect_to contact_fin_path, notice: '問い合わせを送信しました'
    rescue
      render :action => :contact
    end
  end

  def contact_fin
  end

  private

  def search_params
    params.permit(:large_genre_id_eq, :middle_genre_id_eq, :genre_id_eq, :genre_id_eq, :company_id_eq)
    # redirect_to root_url, status: :bad_request, alert: "検索条件がありません" if params.blank?
  rescue
    redirect_to root_url, status: :bad_request, alert: "検索条件が不正です"
  end

  def contact_params
    params.require(:contact).permit(:name, :mail, :content, :machine_id, :company_id, :officer, :tel)
  end
end
