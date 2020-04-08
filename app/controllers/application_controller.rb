class ApplicationController < ActionController::Base
  protect_form_forgery with: :exception

  def hello
    render html: "hello world!"
  end
end
