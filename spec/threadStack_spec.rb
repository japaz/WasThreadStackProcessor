require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'threadStack'

describe ThreadStack do
	describe "After creation" do
		it "must contains the stack passed as an Array" do
			stack = ['at com/ibm/io/async/AsyncLibrary.aio_getioev3(Native Method)',
					'at com/ibm/io/async/AsyncLibrary.getCompletionData3(AsyncLibrary.java:602(Compiled Code))',
					'at com/ibm/io/async/ResultHandler.runEventProcessingLoop(ResultHandler.java:287(Compiled Code))',
					'at com/ibm/io/async/ResultHandler$2.run(ResultHandler.java:881(Compiled Code))',
					'at com/ibm/ws/util/ThreadPool$Worker.run(ThreadPool.java:1551(Compiled Code))']

			threadStack = ThreadStack.new(stack)

			threadStack.call.text.should == 'at com/ibm/ws/util/ThreadPool$Worker.run(ThreadPool.java:1551(Compiled Code))'
			threadStack.call.count.should == 1
			threadStack.call.children[0].text.should == 'at com/ibm/io/async/ResultHandler$2.run(ResultHandler.java:881(Compiled Code))'
			threadStack.call.children[0].children[0].text.should == 'at com/ibm/io/async/ResultHandler.runEventProcessingLoop(ResultHandler.java:287(Compiled Code))'
		end
	end

	describe "A merge" do
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

			@threadStack4 = ThreadStack.new(['at com/ibm/io/async/AsyncLibrary.aio_getioev3(Native Method)',
					'at com/ibm/io/async/AsyncLibrary.getCompletionData3(AsyncLibrary.java:602(Compiled Code))',
					'at com/ibm/io/async/ResultHandler.runEventProcessingLoop(ResultHandler.java:287(Compiled Code))',
					'at com/ibm/io/async/ResultHandler$2.run(ResultHandler.java:881(Compiled Code))',
					'at com/ibm/ws/util/ThreadPool$Worker.run(ThreadPool.java:1551(Compiled Code))'])
		end

		it "must contains two branches after a merge with other ThreadStack with common calls" do
			@threadStack.merge(@threadStack2)
			@threadStack.call.text.should == 'at com/ibm/ws/util/ThreadPool$Worker.run(ThreadPool.java:1551(Compiled Code))'
			@threadStack.call.count.should == 2
			@threadStack.call.children[0].text.should == 'at com/ibm/io/async/ResultHandler$2.run(ResultHandler.java:881(Compiled Code))'
			@threadStack.call.children[0].count.should == 2
			@threadStack.call.children[0].children[0].text.should == 'at com/ibm/io/async/ResultHandler.runEventProcessingLoop(ResultHandler.java:287(Compiled Code))'
			@threadStack.call.children[0].children[0].count.should == 1
			@threadStack.call.children[0].children[1].text.should == 'at java/lang/Object.wait(Native Method)'
			@threadStack.call.children[0].children[1].count.should == 1
		end

		it "must return true if the merge is done" do
			@threadStack.merge(@threadStack2).should be true
		end

		it "must return false if the merge is not done" do
			@threadStack.merge(@threadStack3).should be false
		end

		it "must put count to two in all calls if the thread stacks are the same" do
			@threadStack.merge(@threadStack4)
			@threadStack.call.count.should == 2
			@threadStack.call.children[0].count.should == 2
			@threadStack.call.children[0].children[0].count.should == 2
			@threadStack.call.children[0].children[0].children[0].count.should == 2
			@threadStack.call.children[0].children[0].children[0].children[0].count.should == 2
		end
	end
end