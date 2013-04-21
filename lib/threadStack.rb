class ThreadStack

	class Call
		attr_accessor :text
		attr_accessor :count
		attr_accessor :children

		def initialize(text)
			@text = text
			@children = Array.new
			@count = 1
		end

		def merge(call)
			if call.nil?
				false
			elsif @text == call.text
				@count += 1
				@children.compact!
				if @children.count{ |x| x.merge(call.children[0])} == 0
					@children << call.children[0]
				end
				@children.compact!
				true
			else
				false
			end
		end

		def text_count
			"#{text} - (#{count})"
		end

		def children_sorted
		  children.compact.sort { |a,b| b.count <=> a.count}
		end
	end

	attr_reader :call

	def initialize(stack)
		previousCall = nil
		stack.each { |text|
			call = Call.new(text.chomp)
			if not previousCall.nil?
				call.children << previousCall
			end
			previousCall = call
		}
		@call = previousCall
	end

	def merge(threadStack)
		@call.merge(threadStack.call)
	end

	def children_sorted
		call.children_sorted
	end

	def count
		call.count
	end

	def text_count
		call.text_count
	end
end
