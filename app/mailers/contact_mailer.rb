class ContactMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.send.subject
  #
  def contact(contact)
    @machine = machine
    @contact = contact

    mail(
      # to:       @machine.company.contact_mail,
      to: "bata44883@gmail.com",
      reply_to: @contact.mail,
      subject:  "e-kikai: #{@contact.machine.name} #{@contact.machine.maker} #{@contact.machine.model}についての問い合わせ通知"
    )
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.send_confirmation.subject
  #
  def contact_confirm(machine, contact)
    @machine = machine
    @contact = contact

    mail(
        to:      @contact.mail,
        subject: "e-kikai:問い合わせ送信確認"
    )
  end
end
