From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Latest dm-userspace, with memory reclaim
Date: Sun, 10 Sep 2006 22:45:02 +0900
Message-ID: <200609101345.k8ADj3fg013628@r-dd.iij4u.or.jp>
References: <m3veob7a9d.fsf@guaranine.beaverton.ibm.com>
	<200609101334.k8ADYeHM012649@r-dd.iij4u.or.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200609101334.k8ADYeHM012649@r-dd.iij4u.or.jp>
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

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [dm-devel] [PATCH] Latest dm-userspace, with memory reclaim
Date: Sun, 10 Sep 2006 22:34:39 +0900

> From: Dan Smith <danms@us.ibm.com>
> Subject: [dm-devel] [PATCH] Latest dm-userspace, with memory reclaim
> Date: Tue, 29 Aug 2006 09:54:38 -0700
> 
> > This is the latest version of dm-userspace.  I have added a
> > (configurable) limit on the number of remap objects the kernel will
> > maintain in memory before re-using old ones.
> > 
> > I think it may be beneficial to have a soft and a hard limit on this,
> > to allow allocation to be done if no remaps can be re-used at a given
> > point (up to the hard limit).  Comments appreciated.
> 
> How about removing the remap object mechanism?
> 
> You said that the remap object mechanism improves the performance by
> avoiding contacting user space for every requests. However, as you
> see, Xen blktap (contacting user space for every requests) and blkback
> (doing I/O in kernel) performances are comparable. dm-userspace's poor
> performance of user space access is due to ioctl, an inefficient
> interface. The blktap uses shared ring buffer between kernel and user
> space, which enables us to batch multiple requests without data
> copies.
> 
> Here's a patch to remove the remap object mechanism and add replaced
> ioctl with ring buffer.

The mailing list removed my patch for some reasons. So I uploaded the
patch too:

http://www.kernel.org/pub/linux/kernel/people/tomo/dmu/ringbuf.patch
