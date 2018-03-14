class MainController < ApplicationController
  # before_action :contact_ab_test, only: [:search, :machine, :detail]
  before_action :detail_ab_test,  except: [:contact_fin]

  ### トップページ ###
  def index
    @genres = LargeGenre.list.all.order('large_genres.order_no')
    @companies = Company.all.order('company_kana')

    @middle_genre_counts = MiddleGenre.group("middle_genres.id").includes(:machines).count('machines.id')
  end

  def large_genre
    @large_genre = LargeGenre.find(params[:id])
    @middle_genre_counts = @large_genre.middle_genres.group("middle_genres.id").includes(:machines).count('machines.id')
  end

  ### 検索結果一覧 ###
  def search
    @params = search_params

    # # invoke :test1, :search do
    #   @machines = Machine.search_list(@params)
    #   @names    = Machine.search_names(@params)
    # # end
    # @nmachines = @machines.group_by(&:name)

    # @names     = Machine.search_names(@params)
    # @pnames    = @names.page(params[:page])
    # @machines  = Machine.search_list(@params)
    # @nmachines = @machines.where(name: @pnames.pluck(:name)).group_by(&:name)

    @machines  = Machine.search_list(@params)
    @pmachines = @machines.page(params[:page])

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
        t.large_genre.name  => "/large_genre/#{t.middle_genre.large_genre_id}",
        t.middle_genre.name => "/search?middle_genre_id_eq=#{t.middle_genre_id}"
      }
    elsif @params[:middle_genre_id_eq].present?
      t = MiddleGenre.find(@params[:middle_genre_id_eq])
      titles << t.name
      @breads = {t.large_genre.name  => "/large_genre/#{t.large_genre_id}"}
    elsif @params[:large_genre_id_eq].present?
      t = LargeGenre.find(@params[:large_genre_id_eq])
      titles << t.name
    end

    if @params[:maker_eq].present?
      titles << @params[:maker_eq]
    end

    title = titles.join "/"
    if company.present?
      @title       = "#{title} 在庫機械一覧"
      @description = "#{title}(#{company.addr1})の在庫機械一覧です。中古機械の販売買取はe-kikaiにおまかせ下さい！"
    else
      @title       = "中古#{title}一覧"
      @description = "中古#{title}の在庫一覧を掲載しています。中古#{title}の価格も簡単に問合せ出来ます。中古機械・中古#{title}の販売買取はe-kikaiにおまかせ下さい！"
    end
  rescue => e
    redirect_to "/", alert: "検索エラーが発生しました : " + e.message
  end

  ### 機械詳細 ###
  def machine
    @machine = Machine.find(params[:id])

    q = {genre_id_eq: @machine.genre_id}
    # @machines  = Machine.search_list(q)
    @names     = Machine.search_names(q)
    # @nmachines = Machine.search_list(q).group_by(&:name)
    @nmachines = Machine.search(q).result.select(:id, :name, :maker, :model).group_by(&:name)
  end

  def detail
    @machine = Machine.find(params[:id])

    q = {genre_id_eq: @machine.genre_id}
    @names     = Machine.search_names(q)
    @nmachines = Machine.search(q).result.select(:id, :name, :maker, :model).group_by(&:name)
  end

  ### 機械問い合わせ ###
  def contact
    @machine = Machine.find(params[:id])
    @contact = Contact.new(machine_id: @machine.id, company_id: @machine.company_id)
    @ref     = params[:ref]
  end

  def contact_create
    @machine = Machine.find(params[:contact][:machine_id])
    @contact = Contact.new(contact_params)
    @ref     = params[:ref]

    raise "入力された文字が画像と違っています" unless simple_captcha_valid?

    Contact.transaction do
      @contact[:content] = @ref + @contact[:content]
      @contact.save!

      # ContactMailer.contact(@contact, @machine).deliver_later
      # ContactMailer.contact_confirm(@contact, @machine).deliver_later
      ContactMailer.contact(@contact, @machine).deliver
      ContactMailer.contact_confirm(@contact, @machine).deliver
    end

    ahoy.track(:contact, {id: params[:contact][:machine_id]})

    redirect_to "/contact_fin", notice: '問い合わせを送信しました'
  rescue => e
    flash.now[:alert] = e.message
    render action: :contact
  end

  def contact_fin
    # finished :contact_label
    ab_finished :detail_link
  end

  def about
  end

  def sitemap
    @genres = LargeGenre.list.all.order('large_genres.order_no')
    @companies = Company.all.order('company_kana')

    # @middle_genre_counts = MiddleGenre.group("middle_genres.id").includes(:machines).count('machines.id')
    # @genre_counts = Genre.group("genres.id").includes(:machines).count('machines.id')

    @makers = Machine.group(:maker).order(:maker).pluck(:maker)

    # @genremakers = Machine.joins(:genre).group(:genre_id, "genres.name", :maker).having("count(*) > 5").count.keys
  end

  private

  def search_params
    # invoke :test1, :params do
      params.permit(:large_genre_id_eq, :middle_genre_id_eq, :genre_id_eq, :company_id_eq, :addr1_eq, :maker_eq)
    # end
  rescue
    raise "検索条件が不正です"
  end

  def contact_params
    params.require(:contact).permit(:name, :mail, :content, :machine_id, :company_id, :officer, :tel)
  end

  # def contact_ab_test
  #   @contact_label = ab_test :contact_label, "問い合わせ", "メール"
  # end

  def detail_ab_test
    # @detail_link = ab_test :detail_link, "machine", "detail"
    @detail_link = "machine"
  end
end
