# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).

# Root crumb
crumb :root do
  link "HOME", "/"
end

crumb :large_genre do |large_genre|
  link large_genre.name, "/large_genre/#{large_genre.id}"
end

crumb :search do |title, breads|
  if breads
    breads.each do |name, url|
      link name, url
    end
  end

  link "#{title} 検索結果"
  parent :root
end

crumb :detail do |m|
  if m.large_genre.present?
    parent :large_genre, m.large_genre
  else
    parent :root
  end

  if m.middle_genre.present?
    link m.middle_genre.name, "/search?middle_genre_id_eq=#{m.middle_genre.id}"
  end

  if m.genre.present?
    link m.genre.name, "/search?genre_id_eq=#{m.genre.id}"
  end

  link "#{m.name} #{m.maker} #{m.model}", "/machine/#{m.id}"
end

crumb :contact do |m|
  link "問い合わせフォーム", "/contact/#{m.id}"
  parent :detail, m
end

crumb :companies do |c|
  link "e-kikai Network 会員一覧", "/companies"
  parent :root
end

crumb :help do |title|
  link title
  parent :root
end

### 会社情報 ###
crumb :company_show do |c|
  link "#{c.name}", "/#{c.subdomain}"
end

crumb :company_help do |c, title|
  link   title
  parent :company_show, c
end


### 管理者画面 ###
crumb :member_root do
  link "管理者画面", "/member/"
  parent :root
end

crumb :member_contacts do
  link "問い合わせ一覧", "/member/contacts"
  parent :member_root
end
