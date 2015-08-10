module Test1
  include Chanko::Unit

  active_if do |context, options|
    context.company_user_signed_in?
  end

  scope :controller  do
    function :params do
      params.permit(:large_genre_id_eq, :middle_genre_id_eq, :genre_id_eq, :company_id_eq, :addr1_eq, :maker_eq, :keywords)
    end

    function :search do
      Machine.unit.set_query @params
      @machines = Machine.unit.search_list
      @names    = Machine.unit.search_names
    end
  end

  scope :view do
    function :search_area do
      render "/search"
    end

    function :search_area_for_search do
      render "/search" if params[:keywords].present?
    end
  end

  models do
    expand "Machine" do
      @q = {}

      class_methods do
        def search_list(params = nil)
          unit.set_query params if params.present?

          @q.result
            .order("machines.name, CASE WHEN maker_kana IS NULL OR maker_kana = '' THEN '1' ELSE '0' END, maker_kana, CASE WHEN maker IS NULL OR maker = '' THEN '1' ELSE '0' END, maker, CASE WHEN model = '' THEN '1' ELSE '0' END, model")
        end

        def search_names(params = nil)
          unit.set_query params if params.present?

          @q.result
            .order("large_genres.order_no, middle_genres.order_no, genres.order_no, capacity IS NULL, capacity, machines.name")
            .pluck(:name).uniq
        end

        def set_query(params)
          res = params.map do |k,v|
            if k == "keywords"
              [
                :groupings,
                NKF.nkf("-wZX--cp932", v).upcase.split(/[[:blank:]]/).map do |w|
                  { name_or_maker_or_model_or_addr1_or_addr2_or_addr3_or_spec_or_company_name_cont: w }
                end
              ]
            else
              [k, v]
            end
          end.to_h
          @q = list.search(res)

          raise "検索条件がありません #{@q.result}" if @q.conditions.blank? && res[:groupings].blank?
        end
      end
    end
  end
end
