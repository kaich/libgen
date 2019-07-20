require "libgen/version"
require "libgen/gen"

module Libgen
  def self.gen 
    Gen::run
  end
end
