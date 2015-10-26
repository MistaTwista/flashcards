class OauthsController < ApplicationController
  skip_before_action :require_login
  before_action :require_login, only: :destroy

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if @user = login_from(provider)
      flash[:info] = t('auth.logged_in', provider: provider.titleize)
      redirect_to root_path
    else
      if logged_in?
        link_account(provider)
        redirect_to root_path
      else
        flash[:alert] = t('auth.link_after_sign_in')
        redirect_to login_path
      end
    end
  end

  def destroy
    provider = params[:provider]

    authentication = current_user.authentications.find_by_provider(provider)
    if authentication.present?
      authentication.destroy
      flash[:info] = t('auth.unlinked_successfully', provider: provider.titleize)
    else
      flash[:alert] = t('auth.not_linked', provider: provider.titleize)
    end

    redirect_to root_path
  end

  private

  def link_account(provider)
    if @user = add_provider_to_user(provider)
      flash[:notice] = t('auth.linked_successfully', provider: provider.titleize)
    else
      flash[:alert] = t('auth.link_problem', provider: provider.titleize)
    end
  end

  def auth_params
    params.permit(:code, :provider)
  end
end
