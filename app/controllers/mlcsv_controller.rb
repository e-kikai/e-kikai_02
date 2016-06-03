class MlcsvController < ApplicationController
  def machines
    @machines = Visit.ml_machines(params[:day])
    respond_to do |format|
      format.csv  {
        send_data(render_to_string("machines.csv.ruby"),
          content_type: 'text/csv;charset=shift_jis',
          filename:     "machines_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
        )
      }
    end
  end

  def visitors
    @visitors = Visit.ml_visitors(params[:day])
    respond_to do |format|
      format.csv  {
        send_data(render_to_string("visitors.csv.ruby"),
          content_type: 'text/csv;charset=shift_jis',
          filename:     "visitors_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
        )
      }
    end
  end

  def ratings
    @ratings = Visit.ml_ratings(params[:day])
    respond_to do |format|
      format.csv  {
        send_data(render_to_string("ratings.csv.ruby"),
          content_type: 'text/csv;charset=shift_jis',
          filename:     "ratings_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
        )
      }
    end
  end
end
