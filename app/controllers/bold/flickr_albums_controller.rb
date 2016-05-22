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

