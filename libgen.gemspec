
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "libgen/version"

Gem::Specification.new do |spec|
  spec.name          = "libgen"
  spec.version       = Libgen::VERSION
  spec.authors       = ["kaich"]
  spec.email         = ["chengkai1853@163.com"]

  spec.summary       = %q{为对应平台编译C/C++库}
  spec.description   = %q{为对应平台编译C/C++库, Android编译为.so}
  spec.license       = "MIT"


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "bin"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_runtime_dependency 'colorize' , '~> 0.7'
end
