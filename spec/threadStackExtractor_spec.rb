require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'threadStackExtractor'

describe ThreadStackExtractor do
	it "returns an empty array if the text is empty" do
        file = double("File")
        file.stub(:gets).and_return(nil)
		threadStackExtractor = ThreadStackExtractor.new(file)
		threadStacks = threadStackExtractor.getThreadStacks()

		threadStacks.should be_empty
	end

	it "returns an array with an stack in the text has only one stack" do
        file = double("File")
        file.stub(:gets).and_return('3XMTHREADINFO      "WebContainer : 425" (TID:0x000000000B48E100, sys_thread_t:0x000000000AA11040, state:R, native ID:0x000000000000146B) prio=5',
									'4XESTACKTRACE          at com/ibm/io/async/AsyncLibrary.aio_getioev3(Native Method)',
									'4XESTACKTRACE          at com/ibm/io/async/AsyncLibrary.getCompletionData3(AsyncLibrary.java:602(Compiled Code))',
									'4XESTACKTRACE          at com/ibm/io/async/ResultHandler.runEventProcessingLoop(ResultHandler.java:287(Compiled Code))',
									'4XESTACKTRACE          at com/ibm/io/async/ResultHandler$2.run(ResultHandler.java:881(Compiled Code))',
									'4XESTACKTRACE          at com/ibm/ws/util/ThreadPool$Worker.run(ThreadPool.java:1551(Compiled Code))',
									nil)
		threadStackExtractor = ThreadStackExtractor.new(file)
		threadStacks = threadStackExtractor.getThreadStacks()

		threadStacks[0][0].should == 'at com/ibm/io/async/AsyncLibrary.aio_getioev3(Native Method)'
	end
	
	it "returns an array with four stacks in the text has four stacks" do
        file = double("File")
        file.stub(:gets).and_return('3XMTHREADINFO      "WebContainer : 425" (TID:0x000000000B48E100, sys_thread_t:0x000000000AA11040, state:R, native ID:0x000000000000146B) prio=5',
									'4XESTACKTRACE          at com/ibm/io/async/AsyncLibrary.aio_getioev3(Native Method)',
									'4XESTACKTRACE          at com/ibm/io/async/AsyncLibrary.getCompletionData3(AsyncLibrary.java:602(Compiled Code))',
									'4XESTACKTRACE          at com/ibm/io/async/ResultHandler.runEventProcessingLoop(ResultHandler.java:287(Compiled Code))',
									'4XESTACKTRACE          at com/ibm/io/async/ResultHandler$2.run(ResultHandler.java:881(Compiled Code))',
									'4XESTACKTRACE          at com/ibm/ws/util/ThreadPool$Worker.run(ThreadPool.java:1551(Compiled Code))',
									'3XMTHREADINFO      "NotificationServiceDispatcher : 143" (TID:0x00002AAAD843EF00, sys_thread_t:0x000000000AA1D1C0, state:CW, native ID:0x0000000000000F76) prio=5',
									'4XESTACKTRACE          at java/lang/Object.wait(Native Method)',
									'4XESTACKTRACE          at java/lang/Object.wait(Object.java:231(Compiled Code))',
									'4XESTACKTRACE          at com/ibm/ws/util/BoundedBuffer.waitGet_(BoundedBuffer.java:195(Compiled Code))',
									'4XESTACKTRACE          at com/ibm/ws/util/BoundedBuffer.take(BoundedBuffer.java:564(Compiled Code))',
									'4XESTACKTRACE          at com/ibm/ws/util/ThreadPool.getTask(ThreadPool.java:840(Compiled Code))',
									'4XESTACKTRACE          at com/ibm/ws/util/ThreadPool$Worker.run(ThreadPool.java:1558(Compiled Code))',
									'3XMTHREADINFO      "Java indexing" (TID:0x00002AAAE42C1800, sys_thread_t:0x00002AAAD89EF530, state:CW, native ID:0x0000000000000FA8) prio=4',
									'4XESTACKTRACE          at java/lang/Object.wait(Native Method)',
									'4XESTACKTRACE          at java/lang/Object.wait(Object.java:199(Compiled Code))',
									'4XESTACKTRACE          at org/eclipse/jdt/internal/core/search/processing/JobManager.run(JobManager.java:350)',
									'4XESTACKTRACE          at java/lang/Thread.run(Thread.java:811)',
									'3XMTHREADINFO      "Worker-1" (TID:0x000000000B2C1C00, sys_thread_t:0x00000000088A5208, state:CW, native ID:0x0000000000000FAB) prio=5',
									'4XESTACKTRACE          at java/lang/Object.wait(Native Method)',
									'4XESTACKTRACE          at java/lang/Object.wait(Object.java:231(Compiled Code))',
									'4XESTACKTRACE          at org/eclipse/core/internal/jobs/WorkerPool.sleep(WorkerPool.java:181(Compiled Code))',
									'4XESTACKTRACE          at org/eclipse/core/internal/jobs/WorkerPool.startJob(WorkerPool.java:218(Compiled Code))',
									'4XESTACKTRACE          at org/eclipse/core/internal/jobs/Worker.run(Worker.java:51)',
									nil)
		threadStackExtractor = ThreadStackExtractor.new(file)
		threadStacks = threadStackExtractor.getThreadStacks()

		threadStacks[0][0].should == 'at com/ibm/io/async/AsyncLibrary.aio_getioev3(Native Method)'
		threadStacks[1][0].should == 'at java/lang/Object.wait(Native Method)'
		threadStacks[2][0].should == 'at java/lang/Object.wait(Native Method)'
		threadStacks[3][0].should == 'at java/lang/Object.wait(Native Method)'
	end
end