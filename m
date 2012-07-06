From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-mirror: fix crash with mirror recovery and
	discard
Date: Fri, 6 Jul 2012 14:56:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1207061454200.1119@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-mirror: fix crash with mirror recovery and discard

This patch fixes bug 837607 - crash when mirror recovery happens and a
discard request is sent.

Generally, the following sequence happens during mirror synchronization:
- function do_recovery is called
- do_recovery calls dm_rh_recovery_prepare
- dm_rh_recovery_prepare uses a semaphore to limit the number
  simultaneously recovered regions (by default the semaphore value is 1,
  so only one region at a time is recovered)
- dm_rh_recovery_prepare calls __rh_recovery_prepare,
  __rh_recovery_prepare asks the log driver for the next region to
  recover. Then, it sets the region state to DM_RH_RECOVERING. If there
  are no pending I/Os on this region, the region is added to
  quiesced_regions list. If there are pending I/Os, the region is not
  added to any list. It is added to the quiesced_regions list later (by
  dm_rh_dec function) when all I/Os finish.
- when the region is on quiesced_regions list, there are no I/Os in
  flight on this region. The region popped from the list in
  dm_rh_recovery_start function. Then, kcopyd job is started in the
  recover function.
- when the kcopyd job finishes, recovery_complete is called. It calls
  dm_rh_recovery_end. dm_rh_recovery_end adds the region to
  recovered_regions or failed_recovered_regions list (depending on
  whether the copy operation was successful or not).

The above mechanism assumes that if the region is in DM_RH_RECOVERING
state, no new I/Os are started on this region. When I/O is started,
dm_rh_inc_pending is called, which increases reg->pending count. When
I/O is finished, dm_rh_dec is called. It decreases reg->pending count.
If the count is zero and the region was in DM_RH_RECOVERING state,
dm_rh_dec adds it to the quiesced_regions list.s

Consequently, if we call dm_rh_inc_pending/dm_rh_dec while the region is
in DM_RH_RECOVERING state, it could be added to quiesced_regions list
multiple times or it could be added to this list when kcopyd is copying
data (it is assumed that the region is not on any list while kcopyd does
its jobs). This results in memory corruption and crash.

There already exist bypasses for REQ_FLUSH requests: REQ_FLUSH requests
do not belong to any region, so they are always added to the sync list
in do_writes. dm_rh_inc_pending does not increase count for REQ_FLUSH
requests. In mirror_end_io, dm_rh_dec is never called for REQ_FLUSH
requests. These bypasses avoid the crash possibility described above.

These bypasses were improperly implemented for REQ_DISCARD. In
do_writes, REQ_DISCARD requests is always added on sync queue and
immediatelly dispatched (even if the region is in DM_RH_RECOVERING).
However, dm_rh_inc and dm_rh_dec is called for REQ_DISCARD resusts.
So it violates the rule that no I/Os are started on DM_RH_RECOVERING
regions, and causes the list corruption described above.

This patch changes it so that REQ_DISCARD requests follow the same path
as REQ_FLUSH. This avoids the crash.

Note that we can't guarantee that REQ_DISCARD zeroes the data even if
the underlying disks support zero on discard, so this patch also sets
ti->discard_zeroes_data_unsupported.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org

---
 drivers/md/dm-raid1.c       |    3 ++-
 drivers/md/dm-region-hash.c |    5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

Index: linux-3.4.4-fast/drivers/md/dm-raid1.c
===================================================================
--- linux-3.4.4-fast.orig/drivers/md/dm-raid1.c	2012-07-06 19:01:27.000000000 +0200
+++ linux-3.4.4-fast/drivers/md/dm-raid1.c	2012-07-06 19:03:53.000000000 +0200
@@ -1091,6 +1091,7 @@ static int mirror_ctr(struct dm_target *
 
 	ti->num_flush_requests = 1;
 	ti->num_discard_requests = 1;
+	ti->discard_zeroes_data_unsupported = 1;
 
 	ms->kmirrord_wq = alloc_workqueue("kmirrord",
 					  WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
@@ -1221,7 +1222,7 @@ static int mirror_end_io(struct dm_targe
 	 * We need to dec pending if this was a write.
 	 */
 	if (rw == WRITE) {
-		if (!(bio->bi_rw & REQ_FLUSH))
+		if (!(bio->bi_rw & (REQ_FLUSH | REQ_DISCARD)))
 			dm_rh_dec(ms->rh, map_context->ll);
 		return error;
 	}
Index: linux-3.4.4-fast/drivers/md/dm-region-hash.c
===================================================================
--- linux-3.4.4-fast.orig/drivers/md/dm-region-hash.c	2012-07-06 19:02:28.000000000 +0200
+++ linux-3.4.4-fast/drivers/md/dm-region-hash.c	2012-07-06 19:02:57.000000000 +0200
@@ -404,6 +404,9 @@ void dm_rh_mark_nosync(struct dm_region_
 		return;
 	}
 
+	if (bio->bi_rw & REQ_DISCARD)
+		return;
+
 	/* We must inform the log that the sync count has changed. */
 	log->type->set_region_sync(log, region, 0);
 
@@ -524,7 +527,7 @@ void dm_rh_inc_pending(struct dm_region_
 	struct bio *bio;
 
 	for (bio = bios->head; bio; bio = bio->bi_next) {
-		if (bio->bi_rw & REQ_FLUSH)
+		if (bio->bi_rw & (REQ_FLUSH | REQ_FLUSH))
 			continue;
 		rh_inc(rh, dm_rh_bio_to_region(rh, bio));
 	}
