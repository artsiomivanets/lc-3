require_relative 'lib/vm/version'

Gem::Specification.new do |spec|
  spec.name          = 'vm'
  spec.version       = VM::VERSION
  spec.authors       = ['artsiomivanets']
  spec.email         = ['artem.ivanec96@gmail.com']

  spec.summary       = 'Simple LC-3 virtual machine'
  spec.description   = 'Simple LC-3 virtual machine'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = 'https://github.com'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
