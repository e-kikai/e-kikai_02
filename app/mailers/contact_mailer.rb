class ContactMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.send.subject
  #
  def contact(contact, machine)
    @machine = machine
    @contact = contact

    # mailto = Rails.env.production? ? @machine.company.contact_mail : "bata44883@gmail.com"
    mailto = Rails.env.production? ? @machine.company.contact_mail : @contact.mail

    mail(
      to:       mailto,
      reply_to: @contact.mail,
      subject:  "e-kikai: #{@contact.machine.name} #{@contact.machine.maker} #{@contact.machine.model}についての問い合わせ通知"
    )
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.send_confirmation.subject
  #
  def contact_confirm(contact, machine)
    @machine = machine
    @contact = contact

    mail(
      to:      @contact.mail,
      subject: "e-kikai: 問い合わせ送信確認"
    )
  end
end
