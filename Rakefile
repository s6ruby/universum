require 'hoe'
require './lib/universum/version.rb'

Hoe.spec 'universum' do

  self.version = Universum::VERSION

  self.summary = "universum - next generation ethereum 2.0 world computer runtime; run contract scripts / transactions in plain vanilla / standard ruby on the blockchain; update the (contract-protected / isolated) world states with plain vanilla / standard SQL"
  self.description = summary

  self.urls    = ['https://github.com/s6ruby/universum']

  self.author  = 'Gerald Bauer'
  self.email   = 'wwwmake@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'CHANGELOG.md'

  self.extra_deps = [
    ['safestruct',  '>=1.2.2'],
    ['units-time',  '>=1.1.0'],
    ['units-money', '>=0.1.1'],
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
    required_ruby_version: '>= 2.3'
  }

end
