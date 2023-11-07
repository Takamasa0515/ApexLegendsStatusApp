class ContactsController < ApplicationController
  def new
    @contact = Contact.new(session[:contact] || {})
  end

  def confirm
    @contact = Contact.new(contact_params)
    return unless @contact.invalid?

    session[:contact] = @contact.attributes.slice(*contact_params.keys)
    error_messages = @contact.errors.full_messages
    flash[:name_error] = error_messages.find { |message| message.include?("名前を入力してください") }
    flash[:email_error] = error_messages.detect { |message| message.include?("有効なメールアドレスを入力してください") }
    flash[:message_error] = error_messages.detect { |message| message.include?("お問い合わせ内容を入力してください") }
    redirect_to new_contact_path
  end

  def back
    @contact = Contact.new(contact_params)
    session[:contact] = @contact.attributes.slice(*contact_params.keys)
    redirect_to new_contact_path
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      session[:contact] = @contact.attributes.slice(*contact_params.keys)
      ContactMailer.send_mail(@contact).deliver_now
      redirect_to complete_path
    else
      render :new
    end
  end

  def complete
    @contact = Contact.new(session[:contact])
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :name, :message)
  end
end
