#!/usr/bin/ruby -w

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

threadStackCombinator = ThreadStackCombinator.new
wasThreadStackProcessor = WasThreadStackProcessor.new(threadStackCombinator)

ARGV.each do |file|
	File.open(file, "r") do |infile|
		wasThreadStackProcessor.process(infile)
	end
end

extend Hirb::Console
view  wasThreadStackProcessor, :class=>:parent_child_tree, :type=>:basic, :value_method=>:text_count, :indent=>1, :children_method=>:children_sorted

# wasThreadStackProcessor.threadStackCombinator.combinedThreadStacks.each { |combinedThreadStack| puts combinedThreadStack.call.text}
