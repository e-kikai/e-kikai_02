class MainController < ApplicationController
  ### トップページ ###
  def index
    @genres = LargeGenre.list.all.order('large_genres.order_no, middle_genres.order_no')
    @companies = Company.all.order('company_kana')

    @middle_genre_counts = MiddleGenre.group("middle_genres.id").includes(:machines).count('machines.id')
  end

  def large_genre
    @large_genre = LargeGenre.find(params[:id])
    @middle_genre_counts = @large_genre.middle_genres.group("middle_genres.id").includes(:machines).count('machines.id')
  end

  ### 検索結果一覧 ###
  def search
    @params   = search_params

    @machines  = Machine.search_list(@params)
    @names     = Machine.search_names(@params)
    @nmachines = @machines.group_by(&:name)

    # @addr1s   = Machine.search_addr(@params)
    @addr1s = @machines.map(&:addr1).uniq.reject(&:blank?)

    # 見出し
    titles = []
    @breads = {}

    if @params[:company_id_eq].present?
      company = Company.find(@params[:company_id_eq])
      titles << company.name_strip_kabu
    end

    if @params[:genre_id_eq].present?
      t = Genre.find(@params[:genre_id_eq])
      titles << t.name
      @breads = {
        t.large_genre.name  => large_genre_path(t.middle_genre.large_genre_id),
        t.middle_genre.name => search_path(middle_genre_id_eq: t.middle_genre_id)
      }
    elsif @params[:middle_genre_id_eq].present?
      t = MiddleGenre.find(@params[:middle_genre_id_eq])
      titles << t.name
      @breads = {t.large_genre.name  => large_genre_path(t.large_genre_id)}
    elsif @params[:large_genre_id_eq].present?
      t = LargeGenre.find(@params[:large_genre_id_eq])
      titles << t.name
    end

    if @params[:maker_eq].present?
      titles << @params[:maker_eq]
    end

    if company.present?
      @title       = "#{titles.join("/")} 在庫機械一覧"
      @description = "#{company.name_strip_kabu}(#{company.addr1})の在庫機械一覧"
    else
      @title       = "中古#{titles.join("/")}"
      @description = "#{@title}の中古機械情報が満載"
    end

  end

  ### 機械詳細 ###
  def machine
    @machine   = Machine.find(params[:id])

    q = {middle_genre_id_eq: @machine.genre.middle_genre_id}
    # @machines  = Machine.search_list(q)
    @names     = Machine.search_names(q)
    @nmachines = Machine.search_list(q).group_by(&:name)
  end

  ### 機械問い合わせ ###
  def contact
    @machine = Machine.find(params[:id])
    @contact = Contact.new(machine_id: @machine.id, company_id: @machine.company_id)
  end

  def contact_create
    @machine = Machine.find(params[:contact][:machine_id])
    @contact = Contact.new(contact_params)

    begin
      Contact.transaction do
        @contact.save!

        ContactMailer.contact(@contact, @machine).deliver_later
        ContactMailer.contact_confirm(@contact, @machine).deliver_later
      end

      redirect_to contact_fin_path, notice: '問い合わせを送信しました'
    rescue => e
      flash.now[:alert] = e.message
      render :action => :contact
    end
  end

  def contact_fin
  end

  def about
  end

  def sitemap
    @genres = LargeGenre.list.all.order('large_genres.order_no, middle_genres.order_no, genres.order_no')
    @companies = Company.all.order('company_kana')

    @middle_genre_counts = MiddleGenre.group("middle_genres.id").includes(:machines).count('machines.id')
    @genre_counts = Genre.group("genres.id").includes(:machines).count('machines.id')

    @makers = Machine.group(:maker).order(:maker).pluck(:maker)

    @genremakers = Machine.joins(:genre).group(:genre_id, "genres.name", :maker).having("count(*) > 5").count.keys
  end

  private

  def search_params
    params.permit(:large_genre_id_eq, :middle_genre_id_eq, :genre_id_eq, :company_id_eq, :addr1_eq, :maker_eq)
    # redirect_to root_url, status: :bad_request, alert: "検索条件がありません" if params.blank?
  rescue
    redirect_to "/", status: :bad_request, alert: "検索条件が不正です"
  end

  def contact_params
    params.require(:contact).permit(:name, :mail, :content, :machine_id, :company_id, :officer, :tel)
  end
end
