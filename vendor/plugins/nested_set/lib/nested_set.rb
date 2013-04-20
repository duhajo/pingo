# encoding: utf-8
module CollectiveIdea
  module Acts
    module NestedSet
      autoload :Base,         'nested_set/base'
      autoload :Depth,        'nested_set/depth'
      autoload :Descendants,  'nested_set/descendants'
      autoload :Helper,       'nested_set/helper'
    end
  end
end

require 'nested_set/railtie'
