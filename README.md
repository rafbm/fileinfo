# FileInfo

[![Gem Version](https://badge.fury.io/rb/fileinfo.png)](http://badge.fury.io/rb/fileinfo)
[![Build Status](https://travis-ci.org/rafBM/fileinfo.png?branch=master)](https://travis-ci.org/rafBM/fileinfo)
[![Code Climate](https://codeclimate.com/github/rafBM/fileinfo.png)](https://codeclimate.com/github/rafBM/fileinfo)
[![Coverage Status](https://coveralls.io/repos/rafBM/fileinfo/badge.png?branch=master)](https://coveralls.io/r/rafBM/fileinfo?branch=master)
[![Dependency Status](https://gemnasium.com/rafBM/fileinfo.png)](https://gemnasium.com/rafBM/fileinfo)

FileInfo detects file encodings and MIME types using the [wonderful Unix `file` command](http://en.wikipedia.org/wiki/File_\(command\)).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fileinfo'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install fileinfo
```

## Usage

### Detect encoding

Use `FileInfo.parse` with a string or `FileInfo.load` with a filename.

```ruby
FileInfo.parse('foo bar baz').encoding # => #<Encoding:US-ASCII>
FileInfo.parse('föø bår bàz').encoding # => #<Encoding:UTF-8>

filename = '/Users/rafbm/Downloads/some_crap_coming_from_windows.csv'
FileInfo.load(filename).encoding # => #<Encoding:ISO-8859-1>
```

### Detect MIME type

A bunch of methods are available depending on your needs.

```ruby
info = FileInfo.load('picture.jpg')
info.type       # => "image/jpeg"
info.media_type # => "image"
info.sub_type   # => "jpeg"
```

The `#mime_type` method can also return a `MIME::Type` instance.

```ruby
info = FileInfo.parse('Hello world')
info.mime_type # => #<MIME::Type:0x007f81a1a36090 @content_type="text/plain" ...>
```

**NOTE:** You must install the `mime-types` gem yourself as it is not a dependency of `fileinfo`.

Finally, `#content_type` can be used to get the full string returned by `file --mime --brief`.

```ruby
info = FileInfo.parse('Hëllø wõrld')
info.content_type # => "text/plain; charset=utf-8"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

---

© 2017 [Rafaël Blais Masson](http://rafbm.com). FileInfo is released under the MIT license.
