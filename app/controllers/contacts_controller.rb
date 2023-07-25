class ContactsController < ApplicationController
  def new
    @contact = Contact.new(session[:contact] || {})
  end

  # 確認画面を作成する場合はこのような記述になるかと思います。
  # newアクションから入力内容を受け取り、
  # 送信ボタンを押されたらcreateアクションを実行します。
  def confirm
    @contact = Contact.new(contact_params)
    if @contact.invalid?
      session[:contact] = @contact.attributes.slice(*contact_params.keys)
      error_messages = @contact.errors.full_messages
      flash[:name_error] = error_messages.find{ |message| message.include?("名前を入力してください") }
      flash[:email_error] = error_messages.detect { |message| message.include?("有効なメールアドレスを入力してください") }
      flash[:message_error] = error_messages.detect { |message| message.include?("お問い合わせ内容を入力してください") }
      redirect_to new_contact_path
    end
  end

  # 入力内容に誤りがあった場合、
  # 入力内容を保持したまま前のページに戻るのが当たり前になっているかと思いますが、
  # backアクションを定義することで可能となります。
  def back
    @contact = Contact.new(contact_params)
    session[:contact] = @contact.attributes.slice(*contact_params.keys)
    redirect_to new_contact_path
  end

  # 実際に送信するアクションになります。
  # ここで初めて入力内容を保存します。
  # セキュリティーのためにも一定時間で入力内容の削除を行ってもいいかもしれません。
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

  # 送信完了画面を使用する場合お使いください。
  def complete
    @contact = Contact.new(session[:contact])
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :name, :message)
  end
end
