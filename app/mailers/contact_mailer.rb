class ContactMailer < ApplicationMailer
  def send_mail(contact)
    @contact = contact
    mail(
      from: "contact@example.com",
      to: ENV['TOMAIL'],
      subject: "お問い合わせがありました。"
    )
  end
end
