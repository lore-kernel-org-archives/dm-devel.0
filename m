From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 0/2] patches to improve cluster raid1
	performance [V2]
Date: Thu, 10 Oct 2013 11:29:08 -0500
Message-ID: <66B8343F-84A1-4F8C-B41D-3204EF16651A@redhat.com>
References: <cover.1380191501.git.dmzhang@suse.com>
	<7396AC8F-6B91-44AE-96C1-99C9000F8B4E@redhat.com>
	<52545E0E0200007B0003F696@soto.provo.novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <52545E0E0200007B0003F696@soto.provo.novell.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dong Mao Zhang <dmzhang@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


On Oct 8, 2013, at 3:33 AM, Dong Mao Zhang wrote:

>>>> 
>>>> Brassow Jonathan  09/30/13 10:28 PM >>>
> Hi,
> 
> Couple quick questions/comments:
>>> 1) Can you tell me more about how you are testing and comparing results?
> 
> I just setup a cluster raid1, and compare the performance before and after this patch by 'dd' command.(the block size in dd command is 
> 4k, 8k).
> And it was tested on two kvm nodes. I guess I will test it on the real nodes in the next two week.
> Do you have other suggestions on the test scenario?

Serial I/O is a good start, but won't show how things would perform in the real world.  If you are using cluster mirrors, then you are almost certainly using a clustered file system (e.g. GFS2).  What is the difference in performance when running file system tests on GFS when it is sitting on a linear LV vs a mirror LV vs a mirror LV with your changes?  What happens when you run these benchmarks in parallel from different machines on the same file system?

In the past, I have performed a test that involved untarring 'X' number of linux kernels - each into their own directory which were themselves in a directory that was named after the machine.  Once untarred, the directory and files are removed.  This can be performed for a number of iterations.  Performing a test in a directory named after the machine allows you to run the test in parallel on different machines while reducing file system clustered lock contention - meaning more of the focus is on the I/O performance of the lower layers.  This is just one example of a test that would create many files and directories.  Couple this test with your serial I/O test and you begin to get an idea of what performance would be like for different workloads.  If you want to go further, there are other
  benchmarks our there.

This type of testing satisfies a curiosity about quantifying the improvement, but understanding the patches you sent has already made it obvious that there will be at least some improvement.

> 
> 
>>> There are some comments and other minor things to clean-up after that.  For example, I don't know if I like the name 'DM_SUPPORT_DELAY_FLUSH'...  I might >>rather prefer something that indicates that the 'mark' request is also responsible for 'flush'.  What is happening must be clear to anyone who might write a new >>log daemon in the future.  They must realize that the key change for them is that the 'mark' must handle the 'flush' - everything else is the same from their >>perspective.  It amounts to an API change.
> Yes, I agree to the patch combines.
> And how about the name 'DM_FLUSH_WITH_MARK'? any other ideas?
> 

Sounds fine.  Although it can be confusing whether it should be DM_FLUSH_WITH_MARK (i.e. "flush when mark is performed") or DM_MARK_WITH_FLUSH (i.e. "mark has flush capability").  Perhaps DM_MARK_AND_FLUSH or DM_MARK_PERFORMS_FLUSH or DM_INTEGRATED_MARK_AND_FLUSH...

Thinking more about it...  From the kernel's perspective, it is the /flush/ function that sends the 'mark' requests (but doesn't then send the flush request - it is implicit).  From the userspace perspective, it is the /mark/ function that performs the 'flush' action.  It works and I get it, but it does seem like it could be a source of confusion.  It also makes it tough to come up with a descriptive name, since the kernel and userspace are doing opposite things.

Perhaps a better thing to do is to integrate the marks (and possibly clears) into the flush - DM_INTEGRATED_FLUSH.  The payload for the DM_ULOG_FLUSH flush communication is empty.  It seems to me now that it would make more sense to make use of that empty space and fill it with mark/clear requests.  What do you think?

 brassow
