From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-mirror: fix crash with mirror recovery and discard
Date: Mon, 9 Jul 2012 19:12:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1207091909360.3765@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1207061454200.1119@file.rdu.redhat.com>
	<20120706194859.GA10276@redhat.com>
	<Pine.LNX.4.64.1207061629150.16361@file.rdu.redhat.com>
	<20120709121638.GB30048@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120709121638.GB30048@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Mon, 9 Jul 2012, Mike Snitzer wrote:

> On Fri, Jul 06 2012 at  4:38pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > > > +	ti->discard_zeroes_data_unsupported = 1;
> > > >  
> > > >  	ms->kmirrord_wq = alloc_workqueue("kmirrord",
> > > >  					  WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
> > > 
> > > This should be split out to a separate patch and properly justified in
> > > the patch header.  Is there something unique to dm-mirror that renders
> > > the underlying device's zeroing unreliable?
> > 
> > There are two possible approaches to handling REQ_DISCARD
> > 
> > 1. treat REQ_DISCARD as REQ_FLUSH (this is what the patch does) --- i.e. 
> > do not synchronize it with region states, do not set mirror error on 
> > failure. In this mode we must assume that there are uninitialized data 
> > after a flush.
> > 
> > For example, if there is a region that is being resynchronized and we send 
> > REQ_DISCARD that overlaps this region, there is no guarantee that data in 
> > this region were zeroed. 
> > 
> > - kcopyd reads a few blocks for resynchronization
> > - REQ_DISCARD is sent to both mirror legs, both disks overwrites the area 
> > with zeroes
> > - kcopyd writes those blocks to the other leg => the blocks are no longer 
> > zero despite REQ_DISCARD being sent
> 
> OK, thanks, but my point still stands: this is worthy of a separate
> patch (with the same type of backround you provided above).
> 
> > 2. treat REQ_DISCARD as writes (i.e. synchronize it with region states, 
> > wait until resynchronization finishes, etc.) --- it is possible to do it 
> > this way to, but if we do it this way, we have to split REQ_DISCARD on 
> > region boundaries (it is currently split only on target boundaries, 
> > which is insufficient).
> 
> I think discards should be treated as writes.

You can use this to fix the bug and treat discards as writes. But unlike 
the previous patch, it causes discard splitting on region boundary.

Mikulas

---
 drivers/md/dm.c               |    5 ++++-
 include/linux/device-mapper.h |    6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

Index: linux-3.4.4-fast/drivers/md/dm.c
===================================================================
--- linux-3.4.4-fast.orig/drivers/md/dm.c	2012-07-05 23:55:38.000000000 +0200
+++ linux-3.4.4-fast/drivers/md/dm.c	2012-07-05 23:56:41.000000000 +0200
@@ -1244,7 +1244,10 @@ static int __clone_and_map_discard(struc
 		if (!ti->num_discard_requests)
 			return -EOPNOTSUPP;
 
-		len = min(ci->sector_count, max_io_len_target_boundary(ci->sector, ti));
+		if (!ti->split_discard_requests)
+			len = min(ci->sector_count, max_io_len_target_boundary(ci->sector, ti));
+		else
+			len = min(ci->sector_count, max_io_len(ci->sector, ti));
 
 		__issue_target_requests(ci, ti, ti->num_discard_requests, len);
 
Index: linux-3.4.4-fast/include/linux/device-mapper.h
===================================================================
--- linux-3.4.4-fast.orig/include/linux/device-mapper.h	2012-07-05 23:53:47.000000000 +0200
+++ linux-3.4.4-fast/include/linux/device-mapper.h	2012-07-05 23:59:37.000000000 +0200
@@ -220,6 +220,12 @@ struct dm_target {
 	unsigned discards_supported:1;
 
 	/*
+	 * Set if the target required discard request to be split
+	 * on max_io_len boundary.
+	 */
+	unsigned split_discard_requests:1;
+
+	/*
 	 * Set if this target does not return zeroes on discarded blocks.
 	 */
 	unsigned discard_zeroes_data_unsupported:1;
---
 drivers/md/dm-raid1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-3.4.4-fast/drivers/md/dm-raid1.c
===================================================================
--- linux-3.4.4-fast.orig/drivers/md/dm-raid1.c	2012-07-06 00:00:12.000000000 +0200
+++ linux-3.4.4-fast/drivers/md/dm-raid1.c	2012-07-06 00:01:54.000000000 +0200
@@ -677,8 +677,7 @@ static void do_writes(struct mirror_set 
 	bio_list_init(&requeue);
 
 	while ((bio = bio_list_pop(writes))) {
-		if ((bio->bi_rw & REQ_FLUSH) ||
-		    (bio->bi_rw & REQ_DISCARD)) {
+		if (bio->bi_rw & REQ_FLUSH) {
 			bio_list_add(&sync, bio);
 			continue;
 		}
@@ -1091,6 +1090,7 @@ static int mirror_ctr(struct dm_target *
 
 	ti->num_flush_requests = 1;
 	ti->num_discard_requests = 1;
+	ti->split_discard_requests = 1;
 
 	ms->kmirrord_wq = alloc_workqueue("kmirrord",
 					  WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
