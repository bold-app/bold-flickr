###
bold-flickr - a Flickr plugin for Bold
Copyright (C) 2016 Jens Krämer <jk@jkraemer.net>

This file is part of bold-flickr.

bold-flickr is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

bold-flickr is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with bold-flickr.  If not, see <http://www.gnu.org/licenses/>.
###
window.flickr = {

  markSelectedPhotos: ()->
    selected_ids = $('#asset_ids').val().split(',')
    console.log selected_ids
    $('.flickr .photos .thumb').each (idx, img)->
      $img = $(img)
      photo_id = $img.data('id').toString()
      if selected_ids.indexOf(photo_id) >= 0
        $img.addClass 'selected'

}

$ ->

  $(document).on 'click', '.flickr li.import a', (e)->
    $(this).tab('show')
    e.preventDefault()
    false

  $(document).on 'click', '.flickr .thumb[data-id]', (e) ->
    photo_id = $(this).data('id')
    $(this).toggleClass 'selected'
    thumb = $('.flickr #import .thumb[data-id='+photo_id+']')
    if $(this).hasClass 'selected'
      unless thumb.length > 0
        $('.flickr #import .selected-photos').append $(this).clone()
    else
      thumb.remove()

    asset_ids = $('.flickr #import .thumb')
      .map (idx, img)->
        console.log img
        $(img).data('id')
      .get()

    console.log asset_ids
    $('#asset_ids').val asset_ids.join(',')
    if asset_ids.length > 0
      $('.flickr #import .info').hide()
      $('.flickr #import .import-btn').show()
    else
      $('.flickr #import .info').show()
      $('.flickr #import .import-btn').hide()


    e.preventDefault()
    false
