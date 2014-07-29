# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize
  before_filter :set_i18n_locale_from_params

  private
  
    def current_cart
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
    
    # 管理者のみのアクセス制限の実現
    def authorize
      unless User.find_by_id(session[:user_id])
        redirect_to login_url, notice: "ログインしてください"
      end
    end
    
    # ロケール値を params から設定する
    def set_i18n_locale_from_params
      if params[:locale]
        if I18n.available_locales.include?(params[:locale].to_sym)
          I18n.locale = params[:locale]
        else
          flash.now[:notice] = "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end
      end
    end
    
    # デフォルトとして使用するURLオプションのハッシュを返す
    # ←「ロケールの指定のないページのビューで、ロケールを指定したページのリンクを生成するときに必要となる」とのこと
    def default_url_options
      { locale: I18n.locale }
    end

end

