Flickr plugin for Bold
=========================

This plugin allows to import Photos directly from Flickr.

Installation
------------

### Add the plugin to your Bold installation

Add to your `Gemfile.local`:

    gem 'flickraw', github: 'bold-app/flickraw', branch: 'bold'
    gem 'bold-flickr', github: 'bold-app/bold-flickr'

Run `bundle install`, commit `Gemfile.local` and `Gemfile.lock`, deploy.

### Configure Flickr API key and secret

To get these credentials, sign in to Flickr and go to their
[App registration page](https://www.flickr.com/services/apps).

There are two places where you can set these in Bold:

- As a global setting for the whole installation in `config/flickr.yml`
- As a per-site setting in the site's plugin config. This overrides a possibly
  present global setting.

`config/flickr.yml` should look like this:

    production:
      api_key: 319e8c407cddb53a54213dae71f49b1d
      api_secret: ead9b24bc79af50f

You can also set credentials for any other Rails environments here.


Usage
-----

The "New File" section (click on Files then '+') will have a new navigation
item "Flickr", where you first connect your Bold account with your Flickr
account. After that you can browse your photo stream and Flickr albums, select
photos and import them.


License
-------

Copyright (C) 2016 Jens Krämer <jk@jkraemer.net>

The Bold Flickr plugin is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your option)
any later version.

The Bold Flickr plugin is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
details.

You should have received a copy of the GNU Affero General Public License along
with the Bold Flickr plugin. If not, see
[www.gnu.org/licenses](http://www.gnu.org/licenses/).

Should you be interested in a commercial license without the AGPL's sharing
obligations, please contact the author under the address above.
