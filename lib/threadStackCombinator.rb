class ThreadStackCombinator
	attr_accessor :combinedThreadStacks

	def initialize
		@combinedThreadStacks = Array.new
	end

	def combine(threadStack)
		@combinedThreadStacks << threadStack unless @combinedThreadStacks.count { |combinedThreadStack| combinedThreadStack.merge(threadStack)} > 0
	end
end