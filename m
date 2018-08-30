From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: Snapshot target and DAX-capable devices
Date: Fri, 31 Aug 2018 09:38:09 +1000
Message-ID: <20180830233809.GH1572@dastard>
References: <20180827160744.GE4002@quack2.suse.cz>
 <e38303902267d2d8bae8b0c88da84a4ed668e9fb.camel@hpe.com>
 <20180828075025.GA17756@quack2.suse.cz>
 <20180828175630.GA1197@redhat.com>
 <20180830093028.GC1767@quack2.suse.cz>
 <20180830184907.GA14867@redhat.com>
 <x494lfbabwi.fsf@segfault.boston.devel.redhat.com>
 <alpine.LRH.2.02.1808301545200.30950@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1808301545200.30950-Hpncn10jQN4oNljnaZt3ZvA+iT7yCHsGwRM8/txMwJMAicBL8TP8PQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: dm-devel.ids

On Thu, Aug 30, 2018 at 03:47:32PM -0400, Mikulas Patocka wrote:
> 
> 
> On Thu, 30 Aug 2018, Jeff Moyer wrote:
> 
> > Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> > 
> > > Until we properly add DAX support to dm-snapshot I'm afraid we really do
> > > need to tolerate this "regression".  Since reality is the original
> > > support for snapshot of a DAX DM device never worked in a robust way.
> > 
> > Agreed.
> > 
> > -Jeff
> 
> You can't support dax on snapshot - if someone maps a block and the block 
> needs to be moved, then what?

This is only a problem for access via mmap and page faults.

At the filesystem level, it's no different to the existing direct IO
algorithm for read/write IO - we simply allocate new space, copy the
data we need to copy into the new space (may be no copy needed), and
then write the new data into the new space. I'm pretty sure that for
bio-based IO to dm-snapshot devices the algorithm will be exactly
the same.

However, for direct access via mmap, we have to modify how the
userspace virtual address is mapped to the physical location. IOWs,
during the COW operation, we have to invalidate all existing user
mappings we have for that physical address. This means we have to do
an invalidation after the allocate/copy part of the COW operation.

If we are doing this during a page fault, it means we'll probably
have to restart the page fault so it can look up the new physical
address associated with the faulting user address. After we've done
the invalidation, any new (or restarted) page fault finds the
location of new copy we just made, maps it into the user address
space, updates the ptes and we're all good.

Well, that's the theory. We haven't implemented this for XFS yet, so
it might end up a little different, and we might yet hit unexpected
problems (it's DAX, that's what happens :/).

It's a whole different ballgame for a dm-snapshot device - block
devices are completely unaware of page faults to DAX file mappings.
We'll need the filesystem to be aware it's on a remappable block
device, and when we take a DAX write fault we'll need to ask the
underlying device to remap the block and treat it like the
filesystem COW case above. We'll need to do this remap/invalidate
dance in the write IO path, too, because a COW by the block device
is no different to filesystem COW in that path.

Basically, it's the same algorithm as the filesystem COW case, we
just get the physical location of the data and the notification of
block changing physical location from a different interface.

Hmmmm. ISTR that someone has been making a few noises recently about
virtual block address space mapping interfaces that could help solve
this problem....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
