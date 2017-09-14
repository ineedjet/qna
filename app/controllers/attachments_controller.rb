class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  def destroy
    if current_user.author_of? @attachment.attachable
      flash[:notice] = 'Your attachment successfully deleted'
      @attachment.destroy
    else
      flash[:notice] = 'Premission for attachment denied'
    end
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
