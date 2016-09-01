class Notifier < ApplicationMailer
  # def register_form(user,organization,url)
  #   @user = user
  #   @organization = organization
  #   @url = url
  #   mail(
  #     subject: "Invitation Email",
  #     from: "no_reply@golaunchboard.com",
  #     to: user.email ,
  #     date: Time.now)
  # end

  def new_department_assignment(user,organization,department_name)
    @user = user
    @organization = organization
    @department_name = department_name
    mail(
      subject: "New Department Assignment",
      to: user.email ,
      date: Time.now)
  end

  def user_invitation(email,organization,sender)
    @email = email
    @sender = sender
    @organization = organization
    mail(
      subject: "Launchboard Invitation",
      to: @email,
      date: Time.now)
  end

  # def post_update(post)
  #   @post = post
  #   mail(
  #     subject: "Post Update",
  #     to: post.user.email,
  #     date: Time.now)
  # end

end
