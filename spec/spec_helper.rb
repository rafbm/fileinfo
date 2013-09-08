require 'fileinfo'

RSpec.configure do |config|
  config.order = 'random'

  # Helpers
  config.include Module.new {
    def fixture(filename)
      File.open(File.expand_path("spec/fixtures/#{filename}"))
    end
  }
end
