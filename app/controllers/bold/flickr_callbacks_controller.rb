module Bold
  class FlickrCallbacksController < SiteController

    before_action :check_token

    def show
      if Bold::Flickr::Client.new.get_access_token(
        params[:oauth_token],
        session[:flickr_oauth_secret],
        params[:oauth_verifier]
      )
        flash[:notice] = t('flash.bold.assets.flickr.connect_success')
      else
        flash[:alert] = t('flash.bold.assets.flickr.connect_failure')
      end
      redirect_to new_bold_site_asset_path(current_site, source: 'flickr')
    end

    private

    def check_token
      head 422 and return false if params[:oauth_token] != session[:flickr_oauth_token]
    end

  end
end
