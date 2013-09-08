require 'spec_helper'

describe FileInfo do
  let(:ascii_file)      { fixture('encoding_ascii.csv') }
  let(:isolatin_file)   { fixture('encoding_isolatin.csv') }
  let(:isowindows_file) { fixture('encoding_isowindows.csv') }
  let(:utf8_file)       { fixture('encoding_utf8.csv') }

  let(:utf8_file_with_space) { fixture('encoding utf8.csv') }
  let(:utf8_file_with_space_and_quotes) { fixture('encoding " utf8.csv') }

  describe '.load' do
    it 'extracts encoding from filename' do
      expect(FileInfo.load(ascii_file.path).encoding).to      eq Encoding::US_ASCII
      expect(FileInfo.load(isolatin_file.path).encoding).to   eq Encoding::ISO_8859_1
      expect(FileInfo.load(isowindows_file.path).encoding).to eq Encoding::ISO_8859_1
      expect(FileInfo.load(utf8_file.path).encoding).to       eq Encoding::UTF_8
    end

    it 'extracts encoding from filename with space' do
      expect(FileInfo.load(utf8_file_with_space.path).encoding).to eq Encoding::UTF_8
    end

    it 'extracts encoding from filename with space and quote' do
      expect(FileInfo.load(utf8_file_with_space_and_quotes.path).encoding).to eq Encoding::UTF_8
    end

    it 'raises ArgumentError if file does not exist' do
      expect { FileInfo.load('WRONG!!1') }.to raise_error ArgumentError
    end
  end

  describe '.parse' do
    it 'extracts encoding from string' do
      expect(FileInfo.parse(ascii_file.read).encoding).to      eq Encoding::US_ASCII
      expect(FileInfo.parse(isolatin_file.read).encoding).to   eq Encoding::ISO_8859_1
      expect(FileInfo.parse(isowindows_file.read).encoding).to eq Encoding::ISO_8859_1
      expect(FileInfo.parse(utf8_file.read).encoding).to       eq Encoding::UTF_8
    end
  end
end
