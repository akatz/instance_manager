# -*- encoding: utf-8 -*-
require File.expand_path('../lib/shopkeep_manager/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Avrohom Katz"]
  gem.email         = ["akatz@engineyard.com"]
  gem.description   = %q{Simple gem to interact with aws and describe instances}
  gem.summary       = %q{Search or list instances running shopkeep servers"}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "shopkeep_manager"
  gem.require_paths = ["lib"]
  gem.version       = ShopkeepManager::VERSION

  gem.add_runtime_dependency("thor", "> 0")
  gem.add_runtime_dependency("fog", "> 0")
  gem.add_runtime_dependency("chef", "> 0")
  gem.add_development_dependency("rspec", "> 2.0")
  gem.add_development_dependency("pry", "> 0")
  gem.add_development_dependency("pry-nav", "> 0")
  gem.add_development_dependency("autotest", "> 0")
end


