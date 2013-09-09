# FileInfo

FileInfo detects encoding from strings and files using the [wonderful Unix `file` command](http://en.wikipedia.org/wiki/File_\(command\)).

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

Use `FileInfo.parse` with a string:

```ruby
FileInfo.parse('foo bar baz').encoding # => #<Encoding:US-ASCII>
FileInfo.parse('föø bår bàz').encoding # => #<Encoding:UTF-8>
```

Use `FileInfo.load` with a filename:

```ruby
filename = '/Users/rafbm/Downloads/some_crap_coming_from_windows.csv'
FileInfo.load(filename).encoding # => #<Encoding:ISO-8859-1>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

---

© 2013 [Rafaël Blais Masson](http://heliom.ca). FileInfo is released under the MIT license.
