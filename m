From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/11] bottom-layer barrier support
Date: Fri, 10 Apr 2009 01:11:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904100110370.1117@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904100107160.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100110010.1117@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904100110010.1117@hs20-bc2-1.build.redhat.com>
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

If barrier request was returned with DM_ENDIO_REQUEUE,
requeue it in dm_wq_work instead of dec_pending.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6.30-rc1-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.30-rc1-devel.orig/drivers/md/dm.c	2009-04-10 06:33:17.000000000 +0200
+++ linux-2.6.30-rc1-devel/drivers/md/dm.c	2009-04-10 06:33:20.000000000 +0200
@@ -547,9 +547,10 @@ static void dec_pending(struct dm_io *io
 			 * Target requested pushing back the I/O.
 			 */
 			spin_lock_irqsave(&md->deferred_lock, flags);
-			if (__noflush_suspending(md))
-				bio_list_add_head(&md->deferred, io->bio);
-			else
+			if (__noflush_suspending(md)) {
+				if (!bio_barrier(io->bio))
+					bio_list_add_head(&md->deferred, io->bio);
+			} else
 				/* noflush suspend was interrupted. */
 				io->error = -EIO;
 			spin_unlock_irqrestore(&md->deferred_lock, flags);
@@ -1470,6 +1471,11 @@ static void dm_wq_work(struct work_struc
 
 			if (md->barrier_error != DM_ENDIO_REQUEUE)
 				bio_endio(c, md->barrier_error);
+			else {
+				spin_lock_irq(&md->deferred_lock);
+				bio_list_add_head(&md->deferred, c);
+				spin_unlock_irq(&md->deferred_lock);
+			}
 		}
 
 next_bio:
