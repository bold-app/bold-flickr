#
# bold-flickr - a Flickr plugin for Bold
# Copyright (C) 2016 Jens Krämer <jk@jkraemer.net>
#
# This file is part of bold-flickr.
#
# bold-flickr is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# bold-flickr is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with bold-flickr.  If not, see <http://www.gnu.org/licenses/>.
#
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