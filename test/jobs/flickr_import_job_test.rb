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
require 'test_helper'

class FlickrImportJobTest < ActiveJob::TestCase
  setup do
    @site = create :site
    @user = create :confirmed_user
    @photo_data = [
      {
        'title' => 'A photo',
        'description' => 'yadda yadda',
        'url' => 'https://oft-unterwegs.de/files/inline/7e9aaa6e-c1e4-48b6-8d70-e866ac01359f/teaser',
        'id' => '12345'
      }
    ]
  end

  test 'should import photo' do
    assert_difference 'Asset.count' do
      FlickrImportJob.perform_now @site, @user, @photo_data
    end
    asset = @site.assets.order('created_at DESC').first
    assert_equal @user, asset.creator
    assert_equal 'A photo', asset.title
    assert_equal 'yadda yadda', asset.caption
    assert_equal '12345', asset.meta['flickr_photo_id']
  end

end