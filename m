From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6/7] dm-snapshot: use dm-bufio
Date: Sat, 11 Jan 2014 12:31:38 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401111231000.4018@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401111222400.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111228220.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111229150.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111229390.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111230080.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111230330.4018@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1401111230330.4018@file01.intranet.prod.int.rdu2.redhat.com>
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

Use dm-bufio for initial loading of the exceptions.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap-persistent.c |   39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

Index: linux-3.13-rc7/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm-snap-persistent.c	2014-01-10 03:08:36.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm-snap-persistent.c	2014-01-10 03:40:56.000000000 +0100
@@ -13,6 +13,7 @@
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/dm-io.h>
+#include "dm-bufio.h"
 
 #define DM_MSG_PREFIX "persistent snapshot"
 #define DM_CHUNK_SIZE_DEFAULT_SECTORS 32	/* 16KB */
@@ -494,27 +495,51 @@ static int read_exceptions(struct pstore
 			   void *callback_context)
 {
 	int r, full = 1;
+	struct dm_bufio_client *client;
+
+	client = dm_bufio_client_create(dm_snap_cow(ps->store->snap)->bdev,
+					ps->store->chunk_size << SECTOR_SHIFT,
+					1, 0, NULL, NULL);
+
+	if (IS_ERR(client))
+		return PTR_ERR(client);
 
 	/*
 	 * Keeping reading chunks and inserting exceptions until
 	 * we find a partially full area.
 	 */
 	for (ps->current_area = 0; full; ps->current_area++) {
-		r = area_io(ps, READ);
-		if (r)
-			return r;
+		struct dm_buffer *bp;
+		void *area;
+		chunk_t chunk = area_location(ps, ps->current_area);
+
+		area = dm_bufio_read(client, chunk, &bp);
+		if (unlikely(IS_ERR(area))) {
+			r = PTR_ERR(area);
+			goto ret_destroy_bufio;
+		}
 
-		r = insert_exceptions(ps, ps->area, callback, callback_context,
+		r = insert_exceptions(ps, area, callback, callback_context,
 				      &full);
-		if (r)
-			return r;
+
+		dm_bufio_release(bp);
+
+		dm_bufio_forget(client, chunk);
+
+		if (unlikely(r))
+			goto ret_destroy_bufio;
 	}
 
 	ps->current_area--;
 
 	skip_metadata(ps);
 
-	return 0;
+	r = 0;
+
+ret_destroy_bufio:
+	dm_bufio_client_destroy(client);
+
+	return r;
 }
 
 static struct pstore *get_info(struct dm_exception_store *store)
