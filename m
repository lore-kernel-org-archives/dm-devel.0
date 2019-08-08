From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] direct-io: use GFP_NOIO to avoid deadlock
Date: Thu, 8 Aug 2019 06:53:29 -0700
Message-ID: <20190808135329.GG5482@bombadil.infradead.org>
References: <alpine.LRH.2.02.1908080540240.15519@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1908080540240.15519@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Mike Snitzer <msnitzer@redhat.com>, junxiao.bi@oracle.com, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, honglei.wang@oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Aug 08, 2019 at 05:50:10AM -0400, Mikulas Patocka wrote:
> A deadlock with this stacktrace was observed.
> 
> The obvious problem here is that in the call chain 
> xfs_vm_direct_IO->__blockdev_direct_IO->do_blockdev_direct_IO->kmem_cache_alloc 
> we do a GFP_KERNEL allocation while we are in a filesystem driver and in a 
> block device driver.

But that's not the problem.  The problem is the loop driver calls into the
filesystem without calling memalloc_noio_save() / memalloc_noio_restore().
There are dozens of places in XFS which use GFP_KERNEL allocations and
all can trigger this same problem if called from the loop driver.

>   #14 [ffff88272f5af880] kmem_cache_alloc at ffffffff811f484b
>   #15 [ffff88272f5af8d0] do_blockdev_direct_IO at ffffffff812535b3
>   #16 [ffff88272f5afb00] __blockdev_direct_IO at ffffffff81255dc3
>   #17 [ffff88272f5afb30] xfs_vm_direct_IO at ffffffffa01fe3fc [xfs]
>   #18 [ffff88272f5afb90] generic_file_read_iter at ffffffff81198994
>   #19 [ffff88272f5afc50] __dta_xfs_file_read_iter_2398 at ffffffffa020c970 [xfs]
>   #20 [ffff88272f5afcc0] lo_rw_aio at ffffffffa0377042 [loop]
>   #21 [ffff88272f5afd70] loop_queue_work at ffffffffa0377c3b [loop]
>   #22 [ffff88272f5afe60] kthread_worker_fn at ffffffff810a8a0c
>   #23 [ffff88272f5afec0] kthread at ffffffff810a8428
>   #24 [ffff88272f5aff50] ret_from_fork at ffffffff81745242
