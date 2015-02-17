From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-snapshot: fix a possible invalid memory
 access on unload
Date: Tue, 17 Feb 2015 14:34:00 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502171430540.13128@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When the snapshot target is unloaded, the function snapshot_dtr waits
until pending_exceptions_count drops to zero. Then, it destroys the
snapshot. Therefore, the function that decrements pending_exceptions_count
should not touch the snapshot structure after the decrement.

The function pending_complete calls free_pending_exception (that
decrements pending_exceptions_count) and then it performs
up_write(&s->lock) and it calls retry_origin_bios that dereferences
s->origin. These two memory accesses to the fields of the snapshot may
touch the dm_snapshot struture after it is freed.

This patch moves free_pending_exception to the end of pending_complete, so
that the snapshot could not be destroyed while pending_complete is in
progress.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org

---
 drivers/md/dm-snap.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -1432,8 +1432,6 @@ out:
 		full_bio->bi_private = pe->full_bio_private;
 		atomic_inc(&full_bio->bi_remaining);
 	}
-	free_pending_exception(pe);
-
 	increment_pending_exceptions_done_count();
 
 	up_write(&s->lock);
@@ -1450,6 +1448,8 @@ out:
 	}
 
 	retry_origin_bios(s, origin_bios);
+
+	free_pending_exception(pe);
 }
 
 static void commit_callback(void *context, int success)
