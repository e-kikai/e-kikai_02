class AdminController < ApplicationController
  def crawl
    if params[:target].present?
      CrawlJob.perform_later params[:target]
      redirect_to "/admin/", notice: '同期処理(バックグラウンド)を開始しました。'
    else
      redirect_to "/admin/", alert: '同期ターゲットが指定されていません'
    end
  end
end
