From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Latest dm-userspace, with memory reclaim
Date: Mon, 11 Sep 2006 08:54:24 +0900
Message-ID: <200609102354.k8ANsPoC018868@r-dd.iij4u.or.jp>
References: <m3veob7a9d.fsf@guaranine.beaverton.ibm.com>
	<200609101334.k8ADYeHM012649@r-dd.iij4u.or.jp>
	<m3mz97tzgf.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3mz97tzgf.fsf@guaranine.beaverton.ibm.com>
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
Date: Sun, 10 Sep 2006 10:15:44 -0700

> FT> You said that the remap object mechanism improves the performance
> FT> by avoiding contacting user space for every requests. However, as
> FT> you see, Xen blktap (contacting user space for every requests) and
> FT> blkback (doing I/O in kernel) performances are comparable.
> 
> You may be right.  I suppose the page cache might serve to prevent
> repeated accesses to the same location on disk, thus making the remap
> cache mostly unnecessary?

Yeah, I think that there is no performance difference under real
workloads (not synthetic benchmark workloads).


> FT> dm-userspace's poor performance of user space access is due to
> FT> ioctl, an inefficient interface.
> 
> I do not use ioctl; I assume you're talking about the chardev
> read/write interface...
> 
> Do you have performance metrics that show it performs better without
> the remap cache?  I have gathered the following:
> 
> dbench to an LVM:  250-300 MB/s
> dbench to a dm-user cow, backed by LVM: 200-248 MB/s
> 
> Considering one is doing CoW and one is not, would you consider
> ~50MB/s too much of a hit?
> 
> FT> The blktap uses shared ring buffer between kernel and user space,
> FT> which enables us to batch multiple requests without data copies.
> 
> Well, the remap cache and the read/write interface do as much batching
> as possible to reduce communication with userspace.  Requests are
> copied to/from the kernel, which I suppose limits performance, but the
> request objects are rather small.

Right, I should have said that the major advantage of ring buffer is
communication without system calls.


> FT> Here's a patch to remove the remap object mechanism and add
> FT> replaced ioctl with ring buffer.
> 
> If performance does not suffer, I would love to remove the remap
> cache, as it is really ugly and complicated.  I suppose I have been
> under the assumption that it is absolutely necessary to achieve good
> performance, but if not, I will be the first to rip it out :)
> 
> A performance comparison with/without the remap cache would be
> appreciated. 

I'd like to say the same. :)

I've not tried the origianl dm-userspace. You have all the equipment,
so can you do a performance comparison? I guess that the results of
Xen blktap and blkback drivers have told us the expected performance
differences.
