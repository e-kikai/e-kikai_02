class CompaniesController < ApplicationController
  def index
    @companies = Company.all
  end

  def show
    if params[:subdomain]
      @company = Company.find_by(subdomain: params[:subdomain])
    else
      @company = Company.find(params[:id])
    end

    redirect_to root_path, alert: "e-kikaiメンバ情報が取得できませんでした" unless @company
  end
end
