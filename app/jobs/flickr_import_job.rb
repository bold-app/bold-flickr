class FlickrImportJob < ActiveJob::Base
  queue_as :flickr_import

  # Photos is an array of hashes. expected keys are:
  # title, description, location, date_taken, url.
  # location is a hash with latitude and longitude keys.
  #
  # EXIF metadata in the downloaded photo will take precedence over the flickr
  # metadata for accuracy reasons (i.e. exif timestamps have a time zone,
  # flickr doesn't).
  def perform(site, user, photos)
    logger.info "importing photos:\n#{photos.inspect}"
    @user = user
    Bold.with_site site do
      photos.each{|p| import p}
    end
  end

  private

  def import(photo)
    asset = Site.current.assets.build remote_file_url: photo['url']
    asset.creator = @user
    if asset.save
      asset.title    = photo['title']       if asset.title.blank?
      asset.caption  = photo['description'] if asset.caption.blank?
      asset.taken_on = photo['date_taken']  if asset.taken_on.blank?
      asset.meta['flickr_photo_id'] = photo['id']
      if asset.lat.blank? && asset.lon.blank? && loc = photo['location']
        asset.lat, asset.lon = loc['latitude'], loc['longitude']
      end
      asset.save
    end
  end
end
