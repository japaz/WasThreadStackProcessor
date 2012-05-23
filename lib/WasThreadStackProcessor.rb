

require 'threadStackCombinator'
require 'threadStackExtractor'
require 'threadStack'

require 'rubygems'
require 'hirb'

class WasThreadStackProcessor
	
	attr_accessor :threadStackCombinator

	def initialize(threadStackCombinator)
		@threadStackCombinator = threadStackCombinator
	end

	def process(file)
		threadStackExtractor = ThreadStackExtractor.new(file)
		threadStacks = threadStackExtractor.getThreadStacks

		threadStacks.each { |threadStack| @threadStackCombinator.combine(ThreadStack.new(threadStack))}
	end

	def children_sorted
		threadStackCombinator.combinedThreadStacks.compact.sort { |a,b| b.count <=> a.count}
	end

	def text_count
		""
	end
end
