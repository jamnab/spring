class UserSessionsController < ApplicationController

  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    @user_session = UserSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_session }
    end
  end

  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    @user_session = UserSession.new(params[:user_session])

    respond_to do |format|
      if @user_session.save
        flash[:success] = "You are now logged In"
        format.html { redirect_to(:dashboard) }
        format.xml  { render :xml => @user_session, :status => :created, :location => @user_session }
      else
        flash[:error] = "Your email or password was not correct"
        format.html { redirect_to :back }
        format.xml  { render :xml => @user_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  def destroy
    @user_session = UserSession.find
    if @user_session
      @user_session.destroy
    end

    respond_to do |format|
      format.html { redirect_to(:root, :notice => 'Goodbye!') }
      format.xml  { head :ok }
    end
  end
end
