From: Dave Chinner <david@fromorbit.com>
Subject: Re: Snapshot target and DAX-capable devices
Date: Wed, 5 Sep 2018 11:25:57 +1000
Message-ID: <20180905012557.GE27618@dastard>
References: <20180827160744.GE4002@quack2.suse.cz>
	<e38303902267d2d8bae8b0c88da84a4ed668e9fb.camel@hpe.com>
	<20180828075025.GA17756@quack2.suse.cz>
	<20180828175630.GA1197@redhat.com>
	<20180830093028.GC1767@quack2.suse.cz>
	<20180830184907.GA14867@redhat.com>
	<x494lfbabwi.fsf@segfault.boston.devel.redhat.com>
	<alpine.LRH.2.02.1808301545200.30950@file01.intranet.prod.int.rdu2.redhat.com>
	<20180830233809.GH1572@dastard>
	<20180831094255.GB11622@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180831094255.GB11622@quack2.suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jan Kara <jack@suse.cz>
Cc: Mike Snitzer <snitzer@redhat.com>, "Kani, Toshi" <toshi.kani@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Jeff Moyer <jmoyer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
List-Id: dm-devel.ids

On Fri, Aug 31, 2018 at 11:42:55AM +0200, Jan Kara wrote:
> On Fri 31-08-18 09:38:09, Dave Chinner wrote:
> > On Thu, Aug 30, 2018 at 03:47:32PM -0400, Mikulas Patocka wrote:
> > > You can't support dax on snapshot - if someone maps a block and the block 
> > > needs to be moved, then what?
> > 
> > This is only a problem for access via mmap and page faults.
....
> > It's a whole different ballgame for a dm-snapshot device - block
> > devices are completely unaware of page faults to DAX file mappings.
> 
> Actually, block devices are not completely unaware of DAX page faults -
> they will get ->direct_access callback for the fault range. It does not
> currently convey enough information - we also need to inform the block
> device whether it is read or write. But that's about all that's needed to
> add AFAICT. And by comparing returned PFN with the one we have stored in
> the radix tree (which we have if that file offset is mapped by anybody),
> the filesystem / DAX code can tell whether remapping happened and do the
> unmapping.

I forgot about the direct access call.

But it seems like a hack to redefine the simple, fast sector-to-pfn
translation into a slow and potentially resource hungry interface
for physical storage reallocation.  Doing storage layer COW
operations inside direct_access takes us straight back to the bad
ways of get_block() interfaces. We moved all the filesystem
allocation to iomap so that the storage management is separated from
the mm/physical address translation side of DAX - doing block device
storage management operations inside ->direct_access effectively
reverts that separation and so just seems like a hack to me.

Oh, right, DAX. Silly me. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
