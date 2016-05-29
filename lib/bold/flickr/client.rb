require 'dummydata'
module Bold
  module Flickr
    class Client

      def initialize
        @user = User.current
        @flickr = FlickRaw::Flickr.new api_key:    Bold::Flickr.api_key,
                                       shared_secret: Bold::Flickr.api_secret

        if @user
          @flickr.access_token = user_token
          @flickr.access_secret = user_secret
        end
      rescue
        Rails.logger.error "error initializing flickr client: #{$!}"
      end

      def flickr_user_id
        authorized? unless @flickr_user_id
        return @flickr_user_id
      end

      def flickr_username
        authorized? unless @flickr_username
        return @flickr_username
      end

      def authorized?
        if login = @flickr.test.login
          @flickr_user_id = login.id
          @flickr_username = login.username
        end
        true
      rescue FlickRaw::OAuthClient::FailedResponse
        false
      rescue
        Rails.logger.error "error checking flickr authorization: #{$!}"
        false
      end

      def authorize_url(callback_url, store)
        token = @flickr.get_request_token oauth_callback: callback_url
        store[:flickr_oauth_token] = token['oauth_token']
        store[:flickr_oauth_secret] = token['oauth_token_secret']
        Rails.logger.info "got request token:\n#{token.inspect}"
        @flickr.get_authorize_url(token['oauth_token'], perms: 'read')
      rescue
        Rails.logger.error "error building flickr authorize url: #{$!}"
        nil
      end

      def get_access_token(token, secret, verifier)
        Rails.logger.info "get access token:\n#{token} / #{secret} / #{verifier}"
        @flickr.get_access_token(token, secret, verifier)
        @flickr.test.login

        self.user_token  = @flickr.access_token
        self.user_secret = @flickr.access_secret
        plugin_config.save
      rescue FlickRaw::OAuthClient::FailedResponse
        false
      rescue
        Rails.logger.error "error getting flickr access token: #{$!}"
        nil
      end

      ITEMS_PER_PAGE = 18

      def photos(options = {})
        options[:user_id] = flickr_user_id
        options.reverse_merge! per_page: ITEMS_PER_PAGE, page: 1
        photos = @flickr.people.getPhotos(options)
        make_paginatable photos,
                         page: options[:page]
      end

      def album_photos(album_id, options = {})
        options.update user_id: flickr_user_id, photoset_id: album_id
        options.reverse_merge! per_page: ITEMS_PER_PAGE, page: 1
        album = @flickr.photosets.getPhotos(options)
        photos = make_paginatable album.photo,
                                  page: options[:page],
                                  total: album.total.to_i
        [ album, photos ]
      end

      def albums(options = {})
        options.update user_id: flickr_user_id
        options.reverse_merge! per_page: ITEMS_PER_PAGE,
                               page: 1,
                               primary_photo_extras: 'url_q'
        make_paginatable @flickr.photosets.getList(options),
                         page: options[:page]
      end

      def photo(id)
        @flickr.photos.getInfo photo_id: id
      rescue FlickRaw::FailedResponse
        Rails.logger.error "failed to get photo: #{id}"
        nil
      end

      def get_photo_details(ids)
        ids.map do |id|
          next unless flickr_photo = photo(id)
          flickr_photo.to_hash.slice('id', 'title', 'description').tap do |details|
            details['url'] = FlickRaw.url_o(flickr_photo)
            if tags = flickr_photo['tags']
              details['tags'] = tags.to_a.map{|t|t['raw']}.join(',')
            end
            if dates = flickr_photo['dates']
              details['date_taken'] = dates.to_hash['taken']
            end
            if location = flickr_photo['location']
              details['location'] = location.to_hash.slice('latitude', 'longitude')
            end
          end
        end.compact
      end

      private

      def make_paginatable(flickr_result,
                           page: 1,
                           total: flickr_result.total.to_i)
        Kaminari.paginate_array(flickr_result.to_a,
                                total_count: total).
          page(page).per(ITEMS_PER_PAGE)
      end

      def user_token
        plugin_config.config[user_key('token')]
      end
      def user_token=(t)
        plugin_config.config[user_key('token')] = t
      end

      def user_secret
        plugin_config.config[user_key('secret')]
      end
      def user_secret=(s)
        plugin_config.config[user_key('secret')] = s
      end

      def user_key(what)
        "user_settings_#{@user.id}_#{what}"
      end

      def plugin_config
        @plugin_config ||= Bold::Flickr.site_plugin_config
      end

    end
  end
end
