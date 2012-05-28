From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm optimize: reorder structure
Date: Mon, 28 May 2012 12:44:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1205281243380.4594@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1205281242280.4594@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1205281242280.4594@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-optimize: reorder structure

This reorder actually improves performance by 20% (from 39.1s to 32.8s)
on x86-64 quad core Opteron.

I have no explanation for this, possibly it makes some other entries are
better cache-aligned.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-3.4-rc6-fast/drivers/md/dm.c
===================================================================
--- linux-3.4-rc6-fast.orig/drivers/md/dm.c	2012-05-18 08:06:15.000000000 +0200
+++ linux-3.4-rc6-fast/drivers/md/dm.c	2012-05-18 08:21:52.000000000 +0200
@@ -139,6 +139,13 @@ struct mapped_device {
 	atomic_t holders;
 	atomic_t open_count;
 
+	/*
+	 * The current mapping.
+	 * Use dm_get_live_table{_fast} or take suspend_lock for
+	 * dereference.
+	 */
+	struct dm_table *map;
+
 	unsigned long flags;
 
 	struct request_queue *queue;
@@ -168,13 +175,6 @@ struct mapped_device {
 	struct workqueue_struct *wq;
 
 	/*
-	 * The current mapping.
-	 * Use dm_get_live_table{_fast} or take suspend_lock for
-	 * dereference.
-	 */
-	struct dm_table *map;
-
-	/*
 	 * io objects are allocated from here.
 	 */
 	mempool_t *io_pool;
