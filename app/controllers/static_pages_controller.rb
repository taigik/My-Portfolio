class StaticPagesController < ApplicationController
  before_action :not_logged_in_user, only: [:home]

  def home
  end

  def help
  end

  def about
  end

  def contact
  end

  private
    def not_logged_in_user
      redirect_to user_url(current_user) if logged_in?
    end
end
