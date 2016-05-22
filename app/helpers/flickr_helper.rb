module FlickrHelper
  def flickr
    @flickr ||= Bold::Flickr::Client.new
  end

  def flickr_authorize_url
    flickr.authorize_url bold_site_flickr_callback_url(current_site), session
  end
end

