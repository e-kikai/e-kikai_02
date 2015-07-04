class ContactMailer < ApplicationMailer
  require 'net/pop'

  before_action :authenticate

  def contact(contact, machine)
    @machine = machine
    @contact = contact

    mailto = Rails.env.production? ? @machine.company.contact_mail : @contact.mail

    mail(
      from:    "e-kikai Network<admin@e-kikai.com>",
      to:       mailto,
      reply_to: @contact.mail,
      subject:  "e-kikai: #{@contact.machine.name} #{@contact.machine.maker} #{@contact.machine.model}についての問い合わせ通知"
    )
  end

  def contact_confirm(contact, machine)
    @machine = machine
    @contact = contact

    mail(
      from:    "e-kikai Network<admin@e-kikai.com>",
      to:      @contact.mail,
      subject: "e-kikai: 問い合わせ送信確認"
    )
  end

  def company_contact(contact, company)
    @company = company
    @contact = contact

    mailto = Rails.env.production? ? @machine.company.contact_mail : @contact.mail

    mail(
      from:    "e-kikai Network<admin@e-kikai.com>",
      to:       mailto,
      reply_to: @contact.mail,
      subject:  "e-kikai: #{@company.name}についての問い合わせ通知"
    )
  end

  def company_contact_confirm(contact, company)
    @company = company
    @contact = contact

    mail(
      from:    "e-kikai Network<admin@e-kikai.com>",
      to:      @contact.mail,
      subject: "e-kikai: #{@company.name} 問い合わせ送信確認"
    )
  end

  private

  # POP3認証メソッド
  def authenticate
     Net::POP3.auth_only(self.smtp_settings[:address], 110, Rails.application.secrets.mail_account, Rails.application.secrets.mail_passwd)
  end
end
