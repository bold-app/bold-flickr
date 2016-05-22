require 'bold/flickr/assets_controller_patch'
require 'bold/flickr/client'

module Bold
  module Flickr

    def self.site_plugin_config
      Site.current.plugin_config(:flickr)
    end

    def self.configured?
      api_key.present? and api_secret.present?
    end

    def self.api_key
      key = site_plugin_config['api_key']
      if key.blank?
        global_api_key
      else
        key
      end
    end

    def self.api_secret
      key = site_plugin_config['api_secret']
      if key.blank?
       global_api_secret
      else
        key
      end
    end

    def self.global_config?
      global_api_key.present? && global_api_secret.present?
    end

    def self.config
      Rails.application.config_for(:flickr) rescue {}
    end

    def self.global_api_key
      config['api_key']
    end

    def self.global_api_secret
      config['api_secret']
    end

    class Engine < ::Rails::Engine

      config.to_prepare do

        Bold::Flickr::AssetsControllerPatch.apply

        Bold::Plugin.register(:flickr) do
          name 'Flickr'
          author 'Jens Krämer'
          author_url 'https://jkraemer.net/'

          settings partial: 'settings', defaults: {
            api_key: nil,
            api_secret: nil,
          }

          assets %w( flickr.js flickr.css )

          render_on :view_bold_layout_html_head, 'bold_layout_html_head'
          render_on :view_assets_new_sources_list, 'menu_item'

          routes do
            constraints Bold::Routes::BackendConstraint.new do
              namespace :bold do
                scope 'sites/:site_id', as: :site do
                  get 'flickr/callback' => 'flickr_callbacks#show', as: :flickr_callback
                  resources :flickr_photos, only: %i(index create)
                  resources :flickr_albums, only: %i(index show)
                end
              end
            end
          end
        end

      end

    end

  end
end
