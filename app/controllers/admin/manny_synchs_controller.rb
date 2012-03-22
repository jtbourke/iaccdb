class Admin::MannySynchsController < ApplicationController
  before_filter :authenticate

  def index
    @manny_synchs = MannySynch.includes(:contest).order("manny_number DESC")
  end

  def destroy
    @manny = MannySynch.find(params[:id])
    @manny.contest.destroy if @manny.contest
    @manny.destroy
    redirect_to admin_manny_synchs_url 
  end

  def retrieve
    Delayed::Job.enqueue RetrieveMannyJob.new(params[:manny_number])
    flash[:notice] = "Queued manny number #{params[:manny_number]} for retrieval."
    redirect_to admin_manny_synchs_url
  end

end
