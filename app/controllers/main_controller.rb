class MainController < ApplicationController
  ### トップページ ###
  def index
    @genres = LargeGenre.list.all.order('large_genres.order_no, middle_genres.order_no')
    @companies = Company.all.order('company_kana')

    @middle_genre_counts = MiddleGenre.group("middle_genres.id").includes(:machines).count('machines.id')
  end

  def large_genre
    @large_genre = LargeGenre.find(params[:id])
  end

  ### 検索結果一覧 ###
  def search
    @params   = search_params
    @machines = Machine.search_list(@params)

    @names    = Machine.search_names(@params)
    # @addr1s   = Machine.search_addr(@params)

    # @names = @machines.map(&:name).uniq
    @addr1s = @machines.map(&:addr1).uniq

    # @addr1s = ["2222"]

    # 見出し
    titles = []
    @breads = {}

    if @params[:genre_id_eq]
      t = Genre.find(@params[:genre_id_eq])
      titles << t.name
      @breads = {
        t.large_genre.name  => large_genre_path(t.middle_genre.large_genre_id),
        t.middle_genre.name => search_path(middle_genre_id_eq: t.middle_genre_id)
      }
    elsif @params[:middle_genre_id_eq]
      t = MiddleGenre.find(@params[:middle_genre_id_eq])
      titles << t.name
      @breads = {t.large_genre.name  => large_genre_path(t.large_genre_id)}
    elsif @params[:large_genre_id_eq]
      t = LargeGenre.find(@params[:large_genre_id_eq])
      titles << t.name
    elsif @params[:company_id_eq]
      t = Company.find(@params[:company_id_eq])
      titles << t.name_strip_kabu
    end

    @title = titles.join "/"
  end

  ### 機械詳細 ###
  def machine
    @machine  = Machine.find(params[:id])

    @machines = Machine.search_list(middle_genre_id_eq: @machine.genre.middle_genre.id)
    @names    = Machine.search_names(middle_genre_id_eq: @machine.genre.middle_genre.id)
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

        ContactMailer.contact(@contact, @machine).deliver
        ContactMailer.contact_confirm(@contact, @machine).deliver
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
  end

  private

  def search_params
    params.permit(:large_genre_id_eq, :middle_genre_id_eq, :genre_id_eq, :company_id_eq, :addr1_eq)
    # redirect_to root_url, status: :bad_request, alert: "検索条件がありません" if params.blank?
  rescue
    redirect_to root_url, status: :bad_request, alert: "検索条件が不正です"
  end

  def contact_params
    params.require(:contact).permit(:name, :mail, :content, :machine_id, :company_id, :officer, :tel)
  end
end
