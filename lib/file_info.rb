require 'file_info/version'

require 'shellwords'
require 'tempfile'

class FileInfo
  class UnknownEncodingError < StandardError; end

  CHARSET_REGEX = /charset=(\S+)/

  def initialize(output)
    @output = output
  end

  def charset
    @charset ||= @output.match(CHARSET_REGEX)[1]
  end

  def encoding
    @encoding ||= ::Encoding.find(charset)
  rescue ArgumentError => e
    raise UnknownEncodingError, e.message
  end

  def self.load(filename)
    raise ArgumentError, "File '#{filename}' does not exist." if !File.exists? filename
    new `file --mime --brief #{Shellwords.escape(filename)}`
  end

  def self.parse(content)
    file = Tempfile.new(rand.to_s)
    file.write(content)
    file.rewind
    new `file --mime --brief #{file.path}`
  ensure
    file.close
    file.unlink
  end
end
