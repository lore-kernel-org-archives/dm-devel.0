From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Barriers still not passing on simple dm devices...
Date: Tue, 24 Mar 2009 10:02:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0903241000010.29968@hs20-bc2-1.build.redhat.com>
References: <49C7DD3C.2020401@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49C7DD3C.2020401@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "MASON,
	CHRISTOPHER" <CHRIS.MASON@oracle.com>, Andi Kleen <ak@suse.de>
List-Id: dm-devel.ids



On Mon, 23 Mar 2009, Eric Sandeen wrote:

> I've noticed that on 2.6.29-rcX, with Andi's patch
> (ab4c1424882be9cd70b89abf2b484add355712fa, dm: support barriers on
> simple devices) barriers are still getting rejected on these simple devices.
> 
> The problem is in __generic_make_request():
> 
>                 if (bio_barrier(bio) && bio_has_data(bio) &&
>                     (q->next_ordered == QUEUE_ORDERED_NONE)) {
>                         err = -EOPNOTSUPP;
>                         goto end_io;
>                 }
> 
> and dm isn't flagging its queue as supporting ordered writes, so it's
> rejected here.
> 
> Doing something like this:
> 
> + if (t->barriers_supported)
> +         blk_queue_ordered(q, QUEUE_ORDERED_DRAIN, NULL);
> 
> somewhere in dm (I stuck it in dm_table_set_restrictions() - almost
> certainly the wrong thing to do) did get my dm-linear device to mount
> with xfs, w/o xfs complaining that its mount-time barrier tests failed.
> 
> So what's the right way around this?  What should dm (or md for that
> matter) advertise on their queues about ordered-ness?  Should there be
> some sort of "QUEUE_ORDERED_PASSTHROUGH" or something to say "this level
> doesn't care, ask the next level" or somesuch?  Or should it inherit the
> flag from the next level down?  Ideas?
> 
> Thanks,
> -Eric
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

Hi

This is misdesign in generic bio layer and it should be fixed there. I 
think it is blocking barrier support in md-raid1 too. Jens, pls apply the 
attached patch.

Mikulas

----

Move test for not-supported barriers to __make_request.

This test prevents barriers from being dispatched to device mapper
and md.

This test is sensible only for drivers that use requests (such as disk
drivers), not for drivers that use bios.

It is better to fix it in generic code than to make workaround for it
in device mapper and md.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-core.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6.29-rc6-devel/block/blk-core.c
===================================================================
--- linux-2.6.29-rc6-devel.orig/block/blk-core.c	2009-02-23 18:43:37.000000000 +0100
+++ linux-2.6.29-rc6-devel/block/blk-core.c	2009-02-23 18:44:27.000000000 +0100
@@ -1145,6 +1145,12 @@ static int __make_request(struct request
 	const int unplug = bio_unplug(bio);
 	int rw_flags;
 
+	if (bio_barrier(bio) && bio_has_data(bio) &&
+	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return 0;
+	}
+
 	nr_sectors = bio_sectors(bio);
 
 	/*
@@ -1450,11 +1456,6 @@ static inline void __generic_make_reques
 			err = -EOPNOTSUPP;
 			goto end_io;
 		}
-		if (bio_barrier(bio) && bio_has_data(bio) &&
-		    (q->next_ordered == QUEUE_ORDERED_NONE)) {
-			err = -EOPNOTSUPP;
-			goto end_io;
-		}
 
 		ret = q->make_request_fn(q, bio);
 	} while (ret);
> 
