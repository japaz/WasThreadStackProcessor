class ThreadStackExtractor

	def initialize(file)
		@file = file
	end

	def getThreadStacks
		stacks = Array.new()

		stack = Array.new()
		while (line = @file.gets)
      encoded = line.encode('UTF-8', 'UTF-8', { :invalid => :replace })
			case encoded
				when /^3XMTHREADINFO\s*(.*)/ then
					stacks << stack unless stack.empty?
					stack = Array.new()	
				when /^4XESTACKTRACE\s*(.*)/ then
					stack << $1
			end
		end
		stacks << stack unless stack.empty?

		return stacks
	end
end
