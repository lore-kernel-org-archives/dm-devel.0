From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Latest dm-userspace, with memory reclaim
Date: Mon, 11 Sep 2006 12:39:49 +0900
Message-ID: <200609110339.k8B3doP7009791@r-dd.iij4u.or.jp>
References: <m3mz97tzgf.fsf@guaranine.beaverton.ibm.com>
	<200609102354.k8ANsPoC018868@r-dd.iij4u.or.jp>
	<m3irjvt8w7.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3irjvt8w7.fsf@guaranine.beaverton.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Dan Smith <danms@us.ibm.com>
Subject: Re: [dm-devel] [PATCH] Latest dm-userspace, with memory reclaim
Date: Sun, 10 Sep 2006 19:49:28 -0700

> FT> Yeah, I think that there is no performance difference under real
> FT> workloads (not synthetic benchmark workloads).
> 
> So dbench is too synthetic?  Performance with guest domains has been
> quite good in my experience.

dbench isn't synthetic. I meant that we will see the performance
difference with a benchmark program designed to give I/Os hitting rmap
all the time.


> FT> Right, I should have said that the major advantage of ring buffer
> FT> is communication without system calls.
> 
> That's definitely possible, but if the remap cache reduces the amount
> of communication with userspace, then you also save the context switch
> to map the data each time.  I know that blktap does not seem to suffer
> much of a performance hit here, so it may be lost in the noise of a
> domain switch.  What about native performance?  I intend for
> dm-userspace to be useful outside the realm of Xen :)

Well, I also have an example doing I/Os in user space in native
environments, the SCSI target framework (tgt).

http://stgt.berlios.de/


> FT> I've not tried the origianl dm-userspace. 
> 
> Then why do you claim that performance suffers because of the use of
> syscalls? 

You tried the design without rmap and implemented it due to poor
performance, didn't you?


> FT> You have all the equipment, so can you do a performance
> FT> comparison? 
> 
> Yes, I can.

Great. Thanks in advance.


> FT> I guess that the results of Xen blktap and blkback drivers have
> FT> told us the expected performance differences.
> 
> Is it not possible that blktap performs well for Xen because I/O
> latency is hidden by domain switches?

Maybe. But as I said, I have an example in native environments
too. But I like to wait for your performance comparison results than
expecting the performance now.


> I would think that on a single processor vanilla linux system that
> switching to userspace for every single map would not be ideal.

Yeah, not ideal. However, I think that adding more than 1,000-lines
complicated in-kernel code isn't ideal for unnoticeable performance
gain. We can simplify user-space programs too by deleting invalidating
rmap code.
