From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Barriers still not passing on simple dm devices...
Date: Tue, 24 Mar 2009 10:45:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0903241033070.4088@hs20-bc2-1.build.redhat.com>
References: <49C7DD3C.2020401@redhat.com>
	<Pine.LNX.4.64.0903241000010.29968@hs20-bc2-1.build.redhat.com>
	<20090324140524.GV27476@kernel.dk>
	<Pine.LNX.4.64.0903241010490.29968@hs20-bc2-1.build.redhat.com>
	<20090324143034.GW27476@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090324143034.GW27476@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "MASON,
	CHRISTOPHER" <CHRIS.MASON@oracle.com>, Andi Kleen <ak@suse.de>
List-Id: dm-devel.ids



On Tue, 24 Mar 2009, Jens Axboe wrote:

> On Tue, Mar 24 2009, Mikulas Patocka wrote:
> > 
> > 
> > On Tue, 24 Mar 2009, Jens Axboe wrote:
> > 
> > > On Tue, Mar 24 2009, Mikulas Patocka wrote:
> > > > 
> > > > 
> > > > On Mon, 23 Mar 2009, Eric Sandeen wrote:
> > > > 
> > > > > I've noticed that on 2.6.29-rcX, with Andi's patch
> > > > > (ab4c1424882be9cd70b89abf2b484add355712fa, dm: support barriers on
> > > > > simple devices) barriers are still getting rejected on these simple devices.
> > > > > 
> > > > > The problem is in __generic_make_request():
> > > > > 
> > > > >                 if (bio_barrier(bio) && bio_has_data(bio) &&
> > > > >                     (q->next_ordered == QUEUE_ORDERED_NONE)) {
> > > > >                         err = -EOPNOTSUPP;
> > > > >                         goto end_io;
> > > > >                 }
> > > > > 
> > > > > and dm isn't flagging its queue as supporting ordered writes, so it's
> > > > > rejected here.
> > > > > 
> > > > > Doing something like this:
> > > > > 
> > > > > + if (t->barriers_supported)
> > > > > +         blk_queue_ordered(q, QUEUE_ORDERED_DRAIN, NULL);
> > > > > 
> > > > > somewhere in dm (I stuck it in dm_table_set_restrictions() - almost
> > > > > certainly the wrong thing to do) did get my dm-linear device to mount
> > > > > with xfs, w/o xfs complaining that its mount-time barrier tests failed.
> > > > > 
> > > > > So what's the right way around this?  What should dm (or md for that
> > > > > matter) advertise on their queues about ordered-ness?  Should there be
> > > > > some sort of "QUEUE_ORDERED_PASSTHROUGH" or something to say "this level
> > > > > doesn't care, ask the next level" or somesuch?  Or should it inherit the
> > > > > flag from the next level down?  Ideas?
> > > > > 
> > > > > Thanks,
> > > > > -Eric
> > > > > 
> > > > > --
> > > > > dm-devel mailing list
> > > > > dm-devel@redhat.com
> > > > > https://www.redhat.com/mailman/listinfo/dm-devel
> > > > 
> > > > Hi
> > > > 
> > > > This is misdesign in generic bio layer and it should be fixed there. I 
> > > > think it is blocking barrier support in md-raid1 too. Jens, pls apply the 
> > > > attached patch.
> > > > 
> > > > Mikulas
> > > > 
> > > > ----
> > > > 
> > > > Move test for not-supported barriers to __make_request.
> > > > 
> > > > This test prevents barriers from being dispatched to device mapper
> > > > and md.
> > > > 
> > > > This test is sensible only for drivers that use requests (such as disk
> > > > drivers), not for drivers that use bios.
> > > > 
> > > > It is better to fix it in generic code than to make workaround for it
> > > > in device mapper and md.
> > > 
> > > So you audited any ->make_request_fn style driver and made sure they
> > > rejected barriers?
> > 
> > I didn't.
> > 
> > If you grep for it, you get:
> > 
> > ./arch/powerpc/sysdev/axonram.c:
> > doesn't reject barriers, but it is not needed, it ends all bios in 
> > make_request routine
> > 
> > ./drivers/block/aoe/aoeblk.c:
> > * doesn't reject barriers, should be modified to do so
> > 
> > ./drivers/block/brd.c
> > doesn't reject barriers, doesn't need to, ends all bios in make_request
> > 
> > ./drivers/block/loop.c:
> > doesn't reject barriers, it's ok because it doesn't reorder requests
> > 
> > ./drivers/block/pktcdvd.c
> > * doesn't reject barriers, should be modified to do so
> > 
> > ./drivers/block/umem.c
> > * doesn't reject barriers, I don't know if it reorders requests or not.
> > 
> > ./drivers/s390/block/xpram.c
> > doesn't reject barriers, doesn't need, ends bios immediatelly
> > 
> > ./drivers/md/raid0.c
> > rejects barriers
> > 
> > ./drivers/md/raid1.c
> > supports barriers
> > 
> > ./drivers/md/raid10.c
> > rejects barriers
> > 
> > ./drivers/md/raid5.c
> > rejects barriers
> > 
> > ./drivers/md/linear.c
> > rejects barriers
> > 
> > ./drivers/md/dm.c
> > supports barriers partially
> 
> Not reordering is not enough to support the barrier primitive, unless
> you always go to the same device and pass the barrier flag down with it.

For single-device drivers (not md/dm), not reordering should be good 
enough to claim barrier support.

> I think having the check in generic_make_request() is perfectly fine,
> even if the value doesn't completely apply to stacked devices. Perhaps
> we can add such a value, then. My main point is that barrier support
> should be opt-in, not a default thing.

So make some flag for these bio-based devices, so that they don't have to 
use one of those request-based options (which are meaningless for 
non-request based device).

> Over time we should have support everywhere, but it needs to be checked, 
> audited, and trusted.

BTW. What is the rule for barriers if the device can't prevent the 
requests from being delayed or reordered? (for example ATA<=3 disks with 
cache that lack cache-flush command ... or flash cards that do 
write-caching anyway and it can't be turned off). Should they support 
barriers and try to make best effort? Or should they reject barriers to 
inform the caller code that they have no data consistency?

Mikulas

> -- 
> Jens Axboe
> 
