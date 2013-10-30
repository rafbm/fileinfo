require 'spec_helper'

describe FileInfo do
  let(:ascii_file)      { fixture('encoding_ascii.csv') }
  let(:isolatin_file)   { fixture('encoding_isolatin.csv') }
  let(:isowindows_file) { fixture('encoding_isowindows.csv') }
  let(:macroman_file)   { fixture('encoding_macroman.csv') }
  let(:utf8_file)       { fixture('encoding_utf8.csv') }

  describe '.load' do
    it 'detects encoding from file' do
      expect(FileInfo.load(ascii_file.path).encoding).to      eq Encoding::US_ASCII
      expect(FileInfo.load(isolatin_file.path).encoding).to   eq Encoding::ISO_8859_1
      expect(FileInfo.load(isowindows_file.path).encoding).to eq Encoding::ISO_8859_1
      expect(FileInfo.load(utf8_file.path).encoding).to       eq Encoding::UTF_8
    end

    it 'detects encoding from file with space in filename' do
      old_filename = fixture('encoding_utf8.csv').path
      new_filename = old_filename.sub('_', ' ')
      FileUtils.cp(old_filename, new_filename)

      expect(FileInfo.load(new_filename).encoding).to eq Encoding::UTF_8

      FileUtils.rm(new_filename)
    end

    it 'detects encoding from file with space and quote in filename' do
      old_filename = fixture('encoding_utf8.csv').path
      new_filename = old_filename.sub('_', ' " ')
      FileUtils.cp(old_filename, new_filename)

      expect(FileInfo.load(new_filename).encoding).to eq Encoding::UTF_8

      FileUtils.rm(new_filename)
    end

    it 'raises ArgumentError if file does not exist' do
      expect { FileInfo.load('WRONG!!1') }.to raise_error ArgumentError
    end
  end

  describe '.parse' do
    it 'detects encoding from string' do
      expect(FileInfo.parse(ascii_file.read).encoding).to      eq Encoding::US_ASCII
      expect(FileInfo.parse(isolatin_file.read).encoding).to   eq Encoding::ISO_8859_1
      expect(FileInfo.parse(isowindows_file.read).encoding).to eq Encoding::ISO_8859_1
      expect(FileInfo.parse(utf8_file.read).encoding).to       eq Encoding::UTF_8
    end
  end

  describe '#encoding' do
    it 'raises UnknownEncodingError' do
      expect { FileInfo.load(macroman_file.path).encoding }.to raise_error(FileInfo::UnknownEncodingError)
    end
  end
end
