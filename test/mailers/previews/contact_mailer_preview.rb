# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/contact_mailer/send
  def send
    ContactMailer.send
  end

  # Preview this email at http://localhost:3000/rails/mailers/contact_mailer/send_confirmation
  def send_confirmation
    ContactMailer.send_confirmation
  end

end
