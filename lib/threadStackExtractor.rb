class ThreadStackExtractor

	def initialize(file)
		@file = file
	end

	def getThreadStacks
		stacks = Array.new()

		stack = Array.new()
		while (line = @file.gets)
			case line
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