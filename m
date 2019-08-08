From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] direct-io: use GFP_NOIO to avoid deadlock
Date: Thu, 8 Aug 2019 11:13:50 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1908081112580.18950@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1908080540240.15519@file01.intranet.prod.int.rdu2.redhat.com> <20190808135329.GG5482@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190808135329.GG5482@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Mike Snitzer <msnitzer@redhat.com>, junxiao.bi@oracle.com, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, honglei.wang@oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
List-Id: dm-devel.ids



On Thu, 8 Aug 2019, Matthew Wilcox wrote:

> On Thu, Aug 08, 2019 at 05:50:10AM -0400, Mikulas Patocka wrote:
> > A deadlock with this stacktrace was observed.
> > 
> > The obvious problem here is that in the call chain 
> > xfs_vm_direct_IO->__blockdev_direct_IO->do_blockdev_direct_IO->kmem_cache_alloc 
> > we do a GFP_KERNEL allocation while we are in a filesystem driver and in a 
> > block device driver.
> 
> But that's not the problem.  The problem is the loop driver calls into the
> filesystem without calling memalloc_noio_save() / memalloc_noio_restore().
> There are dozens of places in XFS which use GFP_KERNEL allocations and
> all can trigger this same problem if called from the loop driver.

OK. I'll send a new patch that sets PF_MEMALLOC_NOIO in the loop driver.

Mikulas
