class Member::MainController < ApplicationController
  before_action :authenticate_user!
  before_action :get_company

  ### 会員ページトップページ ###
  def index
  end

  ### 問い合わせログ一覧 ###
  def contacts
    @contacts = @company.contacts.order('created_at DESC')
  end

  ### 会社情報変更フォーム ###
  def company_edit
  end

  def company_update
    if @company.update(company_param)
      redirect_to member_root_path, notice:'会社情報を変更しました'
    else
      render :company_edit
    end
  end

  private

  def get_company
    @company = current_user.company
  end

  def company_param
    params.require(:company).permit(:name, :company_kana, :representative, :officer, :tel, :fax, :mail, :zip, :addr1, :addr2, :addr3, :website)
  end
end
