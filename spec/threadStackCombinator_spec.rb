require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'threadStackCombinator'

describe ThreadStackCombinator do

	before(:each) do
		@threadStackCombinator = ThreadStackCombinator.new
	end

	describe 'after creation' do
		it 'must contain no CombinedThreadStack' do
			@threadStackCombinator.combinedThreadStacks.size.should be 0
		end
	end

	describe 'after combine' do
		before(:each) do
			@threadStack = ThreadStack.new(['at com/ibm/io/async/AsyncLibrary.aio_getioev3(Native Method)',
						'at com/ibm/io/async/AsyncLibrary.getCompletionData3(AsyncLibrary.java:602(Compiled Code))',
						'at com/ibm/io/async/ResultHandler.runEventProcessingLoop(ResultHandler.java:287(Compiled Code))',
						'at com/ibm/io/async/ResultHandler$2.run(ResultHandler.java:881(Compiled Code))',
						'at com/ibm/ws/util/ThreadPool$Worker.run(ThreadPool.java:1551(Compiled Code))'])

			@threadStack2 = ThreadStack.new(['at java/lang/Object.wait(Native Method)',
					'at com/ibm/io/async/ResultHandler$2.run(ResultHandler.java:881(Compiled Code))',
					'at com/ibm/ws/util/ThreadPool$Worker.run(ThreadPool.java:1551(Compiled Code))'])

			@threadStack3 = ThreadStack.new(['at java/lang/Object.wait(Native Method)',
					'at com/ibm/io/async/ResultHandler$2.run(ResultHandler.java:881(Compiled Code))'])			
		end

		it 'one threadStack must contain one threadStack' do
			@threadStackCombinator.combine(@threadStack)

			@threadStackCombinator.combinedThreadStacks.size.should be 1

		end

		it 'two threadStacks with common accesor must contain on threadStack' do
			@threadStackCombinator.combine(@threadStack)
			@threadStackCombinator.combine(@threadStack2)

			@threadStackCombinator.combinedThreadStacks.size.should be 1
		end

		it 'two threadStacks with no common accesor must contain on threadStack' do
			@threadStackCombinator.combine(@threadStack)
			@threadStackCombinator.combine(@threadStack3)

			@threadStackCombinator.combinedThreadStacks.size.should be 2
		end
	end
end
