module Mongoid
	module Document
		def self.included base
			base.extend(ClassMethods)
		end

		module ClassMethods
			def foo
				"bar"
			end
		end
	end
end