# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = "know"
  gem.homepage           = "https://know.dev"
  gem.license            = "Unlicense"
  gem.summary            = "The Know Framework for Ruby"
  gem.description        = ""
  gem.metadata           = {
    'bug_tracker_uri'   => "https://github.com/KnowOntology/know.rb/issues",
    'changelog_uri'     => "https://github.com/KnowOntology/know.rb/blob/master/CHANGES.md",
    'documentation_uri' => "https://github.com/KnowOntology/know.rb/blob/master/README.md",
    'homepage_uri'      => gem.homepage,
    'source_code_uri'   => "https://github.com/KnowOntology/know.rb",
  }

  gem.author             = "KNOW Project"
  gem.email              = "support@know.dev"

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS CHANGES.md README.md UNLICENSE VERSION) + Dir.glob('lib/**/*.rb')
  gem.bindir             = %q(bin)
  gem.executables        = %w()

  gem.required_ruby_version = '>= 2.6'  # macOS 12+
end
