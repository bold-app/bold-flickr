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
  class FlickrAlbumsController < SiteController
    include FlickrHelper

    def index
      @albums = flickr.albums(page: params[:page])
      render layout: false
    end

    def show
      @album, @photos = flickr.album_photos params[:id], page: params[:page]
    end

  end
end