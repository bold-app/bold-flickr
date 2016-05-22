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
