require 'spec_helper'

describe FileInfo do
  let(:one_byte_file)   { fixture('one_byte.txt') }
  let(:ascii_file)      { fixture('encoding_ascii.csv') }
  let(:isolatin_file)   { fixture('encoding_isolatin.csv') }
  let(:isowindows_file) { fixture('encoding_isowindows.csv') }
  let(:macroman_file)   { fixture('encoding_macroman.csv') }
  let(:utf8_file)       { fixture('encoding_utf8.csv') }

  let(:photoshop_file)  { fixture('mockup.psd') }
  let(:binary_file)     { fixture('bytes') }

  describe '#charset' do
    it 'returns encoding string' do
      expect(FileInfo.parse('h').charset).to                 eq 'binary'
      expect(FileInfo.load(ascii_file.path).charset).to      eq 'us-ascii'
      expect(FileInfo.load(isolatin_file.path).charset).to   eq 'iso-8859-1'
      expect(FileInfo.load(isowindows_file.path).charset).to eq 'iso-8859-1'
      expect(FileInfo.load(utf8_file.path).charset).to       eq 'utf-8'
    end
  end

  describe '#encoding' do
    it 'returns Encoding instance' do
      expect(FileInfo.load(one_byte_file.path).encoding).to   eq Encoding::BINARY
      expect(FileInfo.load(ascii_file.path).encoding).to      eq Encoding::US_ASCII
      expect(FileInfo.load(isolatin_file.path).encoding).to   eq Encoding::ISO_8859_1
      expect(FileInfo.load(isowindows_file.path).encoding).to eq Encoding::ISO_8859_1
      expect(FileInfo.load(utf8_file.path).encoding).to       eq Encoding::UTF_8
    end

    it 'raises UnknownEncodingError' do
      expect { FileInfo.load(macroman_file.path).encoding }.to raise_error(FileInfo::UnknownEncodingError)
    end
  end

  describe '.load' do
    it 'accepts filename with space' do
      old_filename = fixture('encoding_utf8.csv').path
      new_filename = old_filename.sub('_', ' ')
      FileUtils.cp(old_filename, new_filename)

      expect(FileInfo.load(new_filename).encoding).to eq Encoding::UTF_8

      FileUtils.rm(new_filename)
    end

    it 'accepts filename with space and quote' do
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
    it 'accepts a string' do
      expect(FileInfo.parse(ascii_file.read).encoding).to      eq Encoding::US_ASCII
      expect(FileInfo.parse(isolatin_file.read).encoding).to   eq Encoding::ISO_8859_1
      expect(FileInfo.parse(isowindows_file.read).encoding).to eq Encoding::ISO_8859_1
      expect(FileInfo.parse(utf8_file.read).encoding).to       eq Encoding::UTF_8
    end

    context 'when internal encoding is UTF-8 (like Rails enforces)' do
      around do |example|
        previous_encoding = Encoding.default_internal
        Encoding.default_internal = Encoding::UTF_8
        example.run
        Encoding.default_internal = previous_encoding
      end

      [Encoding::ASCII_8BIT, Encoding::US_ASCII].each do |encoding|
        it "accepts #{encoding} characters with no UTF-8 equivalent" do
          expect { FileInfo.parse("\xFF".force_encoding(encoding)) }.not_to raise_error
        end
      end
    end
  end

  let(:txt) { FileInfo.parse('Hello, world!') }
  let(:csv) { FileInfo.load(utf8_file.path) }
  let(:psd) { FileInfo.load(photoshop_file.path) }
  let(:empty) { FileInfo.parse('') }
  let(:bytes) { FileInfo.load(binary_file.path) }

  describe '#content_type' do
    it 'returns full Content-Type string' do
      expect(txt.content_type).to eq 'text/plain; charset=us-ascii'
      expect(csv.content_type).to eq 'text/plain; charset=utf-8'
      expect(psd.content_type).to eq 'image/vnd.adobe.photoshop; charset=binary'
      expect(empty.content_type).to match %r{(application|inode)/x-empty; charset=binary}
      expect(bytes.content_type).to eq 'application/octet-stream; charset=binary'
    end
  end

  describe '#type' do
    it 'returns MIME type string' do
      expect(txt.type).to eq 'text/plain'
      expect(csv.type).to eq 'text/plain'
      expect(psd.type).to eq 'image/vnd.adobe.photoshop'
      expect(empty.type).to match %r{(application|inode)/x-empty}
      expect(bytes.type).to eq 'application/octet-stream'
    end
  end

  describe '#media_type' do
    it 'returns MIME media type string' do
      expect(txt.media_type).to eq 'text'
      expect(csv.media_type).to eq 'text'
      expect(psd.media_type).to eq 'image'
      expect(empty.media_type).to match %r{(application|inode)}
      expect(bytes.media_type).to eq 'application'
    end
  end

  describe '#sub_type' do
    it 'returns MIME sub type string' do
      expect(txt.sub_type).to eq 'plain'
      expect(csv.sub_type).to eq 'plain'
      expect(psd.sub_type).to eq 'vnd.adobe.photoshop'
      expect(empty.sub_type).to eq 'x-empty'
      expect(bytes.sub_type).to eq 'octet-stream'
    end
  end

  describe '#mime_type' do
    it 'returns a MIME::Type instance' do
      [txt, csv, psd, bytes].each do |fileinfo|
        expect(fileinfo.mime_type).to be_a MIME::Type
      end
    end

    it 'returns nil for empty file' do
      expect(empty.mime_type).to eq nil
    end

    context 'when "mime-types" gem is not available' do
      before do
        hide_const 'MIME::Types'
        allow_any_instance_of(FileInfo).to receive(:require).with('mime/types').and_raise(LoadError)
      end

      it 'raises LoadError with custom message' do
        expect { txt.mime_type }.to raise_error(LoadError, FileInfo::MIME_TYPE_ERROR_MESSAGE)
      end
    end
  end
end
