require 'file_info/version'

require 'shellwords'
require 'tempfile'

class FileInfo
  class UnknownEncodingError < StandardError; end

  ENCODING_REGEX = /charset=(\S+)/

  def initialize(output)
    @output = output
  end

  def encoding
    @encoding ||= ::Encoding.find(encoding_string)
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

private

  def string
    @string ||= @output.strip
  end

  def encoding_string
    @encoding_string ||= string.match(ENCODING_REGEX)[1]
  end
end
