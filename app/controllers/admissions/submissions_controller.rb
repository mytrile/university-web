class Admissions::SubmissionsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:new, :create]
  skip_before_filter :change_password_if_needed, :only => [:new, :create]
  
  def index
    @submissions = Admissions::Submission.order("created_at")
    
    render :text => "todo"
  end
  
  def new
    @user = User.new
    @user.admissions_submission = Admissions::Submission.new
    
    @open = Course.find_by_id(11).try(:available_slots) || 0
  end
  
  def create
    @user = User.new(params[:user])
    @user.admissions_submission ||= Admissions::Submission.new

    if @user.save
      @user.update_attribute(:requires_password_change, false)
      @user.update_attribute(:access_level, "applicant")
      
      flash[:notice] = "Your application has been sucessfully created!"

      sign_in(@user)

      redirect_to dashboard_path
    else
      render :action => :new
    end
  end
end
