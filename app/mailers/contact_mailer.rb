class ContactMailer < ApplicationMailer
  def send_mail(contact)
    @contact = contact
    mail(
      from: "contact@example.com",
      to: ENV.fetch('TOMAIL', nil),
      subject: "お問い合わせがありました。"
    )
  end
end
