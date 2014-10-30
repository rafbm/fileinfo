require 'file_info/version'

require 'shellwords'
require 'tempfile'

class FileInfo
  class UnknownEncodingError < StandardError; end

  MIME_TYPE_REGEX = /^[^;]+/
  CHARSET_REGEX = /charset=(\S+)/

  MIME_TYPE_ERROR_MESSAGE = 'You must install the "mime-types" gem to use FileInfo#mime_type'

  attr_reader :content_type

  def initialize(output)
    @content_type = output.strip
  end

  def type
    @type ||= content_type.match(MIME_TYPE_REGEX)[0]
  end

  def media_type
    @media_type ||= type.split('/')[0]
  end

  def sub_type
    @sub_type ||= type.split('/')[1]
  end

  def mime_type
    @mime_type ||= begin
      require 'mime/types' unless defined? MIME::Types
      MIME::Types[type][0]
    rescue LoadError
      raise LoadError, MIME_TYPE_ERROR_MESSAGE
    end
  end

  def charset
    @charset ||= (matches = content_type.match(CHARSET_REGEX)) ? matches[1] : 'binary'
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
    file = Tempfile.new(rand.to_s, encoding: Encoding::ASCII_8BIT)
    file.write(content)
    file.rewind
    new `file --mime --brief #{file.path}`
  ensure
    file.close
    file.unlink
  end
end
