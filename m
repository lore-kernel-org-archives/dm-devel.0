From: NeilBrown <neilb@suse.com>
Subject: Re: dm-snap deadlock in pending_complete()
Date: Tue, 18 Aug 2015 16:29:48 +1000
Message-ID: <20150818162948.4e27a969@noble>
References: <20150810135551.64d7dbac@noble>
	<alpine.LRH.2.02.1508110509420.2623@file01.intranet.prod.int.rdu2.redhat.com>
	<20150812114631.15268065@noble>
	<alpine.LRH.2.02.1508121215430.12043@file01.intranet.prod.int.rdu2.redhat.com>
	<20150813104355.485ed63d@noble>
	<alpine.LRH.2.02.1508170657030.29294@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1508170657030.29294@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 17 Aug 2015 09:48:57 -0400 (EDT) Mikulas Patocka
<mpatocka@redhat.com> wrote:

> 
> 
> On Thu, 13 Aug 2015, NeilBrown wrote:

> > Or we could change __split_and_process_bio to use bio_split() to split
> > the bio, then handle the first and call generic_make_request on the
> > second.  That would effectively put the second half on the end of
> > bio_list so it wouldn't be tried until all requests derived from the
> > first half have been handled.
> 
> I don't think it will fix the bug - even if you put the second half of the 
> bio at the end of bio_list, it will still wait until other entries on the 
> bio list are processed.
> 
> For example - device 1 gets a bio, splits it to bio1 and bio2, forwards 
> them to device 2 and put them on current->bio_list
> 
> Device 2 receives bio1 (popped from curretn->bio_list), splits it to bio3 
> and bio4, forwards them to device 3 and puts them at the end of 
> current->bio_list
> 
> Device 2 receives bio2 (popped from current->bio_list), waits until bio1 
> finishes, but bio1 won't ever finish because it depends on bio3 and bio4 
> that are on current->bio_list.
>

Yes, you are right.  I think I was thinking of a slightly different sort
of problem.

That is more insidious than I imagined, but maybe it leads to a fairly
straight forward solution.

Suppose we treated current->bio_list like a stack instead of a queue.

In your example, bio would be split into bio1 and bio2 that are both
pushed onto the stack - lets push them in reverse order to maintain a
similar set of dependencies.  So push bio2 then bio1.

Then bio1 is popped off, split into bio3 and bio4, and pushed back.

bio3 is popped and handled - nothing new pushed.
bio4 is popped and handled - nothing new pushed.
bio2 is popped, waits for bio1 - which will complete as nothing stops it
- and then proceed (probably gets split into bio4 and bio5).

The key idea here is that a bio for a lower-level device (lower in the
stacking order, where filesystem is at the top and hardware at the
bottom) is never placed after (beneath) a bio for an upper level device
in the stack.  So we always handle the lower-level bios first.

This makes sense as upper level devices may want to wait for lower
level devices, but never the reverse.

We probably don't want a strict stack discipline as if one driver
submits two bios, they should still be processed in that order.
Rather: each call to a make_request_fn gets a new queue to attach
bios to, and when it completes, this queue is pushed onto the stack of
other pending bios.

Something like this.


diff --git a/block/blk-core.c b/block/blk-core.c
index 627ed0c593fb..b4663eed7615 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1961,12 +1961,15 @@ void generic_make_request(struct bio *bio)
 	 * bio_list, and call into ->make_request() again.
 	 */
 	BUG_ON(bio->bi_next);
-	bio_list_init(&bio_list_on_stack);
-	current->bio_list = &bio_list_on_stack;
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+		struct bio_list remainder;
 
+		remainder = bio_list_on_stack;
+		bio_list_init(&bio_list_on_stack);
+		current->bio_list = &bio_list_on_stack;
 		q->make_request_fn(q, bio);
+		bio_list_merge(&bio_list_on_stack, &remainder);
 
 		bio = bio_list_pop(current->bio_list);
 	} while (bio);


So before handling a bio we put all other delayed bios (which must be
for devices on the same or a higher level) in 'remainder' and initialize
bio_list_on_stack which becomes current->bio_list.
bios submitted by that make_request_fn call (all for lower-level
devices) are collected in bio_list_on_stack which is then pushed onto
the remainder (actually remainder is spliced underneath
bio_list_on_stack).

Then the top bio is handled.  If  the most recent make_request_fn
submitted any bios, this will be the first of those, otherwise it will
whatever is next from some previous call.


This isn't sufficient by itself.  It still needs dm_make_request to
split a bio of the front of the original bio, map that, then submit the
mapped bio and the remains of the split bio.

I imagine something vaguely like this:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ab37ae114e94..977678ff8d82 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1711,8 +1711,11 @@ static void __split_and_process_bio(struct mapped_device *md,
 	} else {
 		ci.bio = bio;
 		ci.sector_count = bio_sectors(bio);
-		while (ci.sector_count && !error)
-			error = __split_and_process_non_flush(&ci);
+		error = __split_and_process_non_flush(&ci);
+		if (!error && ci.sector_count) {
+			bio->bi_iter.bi_size = to_bytes(ci.sector_count);
+			generic_make_request(bio);
+		}
 	}
 
 	/* drop the extra reference count */


Though that is wrong at least because it doesn't create a proper linkage
between the old 'bio' and the clone created by clone_bio().
This would result in cloned part being fully processed before the
remainder is looked at at all.

NeilBrown
