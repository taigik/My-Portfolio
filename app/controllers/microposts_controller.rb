class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:destroy]

  def create
    @user = current_user
    @microposts = @user.microposts.paginate(page: params[:page])
    @micropost = current_user.microposts.build(micropost_params)
      if @micropost.save
      flash[:success] = "投稿しました。"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page]) if logged_in?
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "投稿を削除しました。"
    redirect_back(fallback_location: root_url)
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      if current_user.admin?
        @micropost = Micropost.find_by(id: params[:id])
      else
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
      end
    end
end
