From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/3] check for completed exception after dropped
	lock
Date: Wed, 25 Feb 2009 12:58:39 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902251258130.30903@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

We need to check if the exception was completed after dropping the lock.

After regaining the lock, __find_pending_exception checks if the exception
was already placed into &s->pending hash.

But we don't check if the exception was already completed and placed into
&s->complete hash. If the process waiting in alloc_pending_exception was
delayed at this point because of a scheduling latency and the exception
was meanwhile completed, we'd miss that and allocate another pending
exception for already completed chunk.

It will lead to a situation when two records for the same chunk exist and
it could lead to data corruption because multiple snapshot I/Os to the
affected chunk could be redirected to different locations in the snapshot.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: linux-2.6.29-rc6-devel/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.29-rc6-devel.orig/drivers/md/dm-snap.c	2009-02-25 18:30:30.000000000 +0100
+++ linux-2.6.29-rc6-devel/drivers/md/dm-snap.c	2009-02-25 18:36:36.000000000 +0100
@@ -1080,6 +1080,13 @@ static int snapshot_map(struct dm_target
 				goto out_unlock;
 			}
 
+			e = lookup_exception(&s->complete, chunk);
+			if (e) {
+				free_pending_exception(pe);
+				remap_exception(s, e, bio, chunk);
+				goto out_unlock;
+			}
+
 			pe = __find_pending_exception(s, pe, chunk);
 			if (!pe) {
 				__invalidate_snapshot(s, -ENOMEM);
@@ -1226,6 +1233,12 @@ static int __origin_write(struct list_he
 				goto next_snapshot;
 			}
 
+			e = lookup_exception(&snap->complete, chunk);
+			if (e) {
+				free_pending_exception(pe);
+				goto next_snapshot;
+			}
+
 			pe = __find_pending_exception(snap, pe, chunk);
 			if (!pe) {
 				__invalidate_snapshot(snap, -ENOMEM);
