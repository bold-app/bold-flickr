module Bold
  class FlickrPhotosController < SiteController
    include FlickrHelper

    def index
      @photos = flickr.photos(page: params[:page])
    end

    def create
      ids = params[:asset_ids].to_s.split(',')
      logger.info "importing:\n#{ids.inspect}"
      if ids.any?
        photos = flickr.get_photo_details ids
        if photos.any?
          FlickrImportJob.perform_later current_site, photos
          flash[:notice] = I18n.t('flash.bold.flickr_photos.importing', count: photos.size)
        end
      end
      redirect_to new_bold_site_asset_path(current_site, source: 'flickr')
    end


  end
end
