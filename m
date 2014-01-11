From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7/7] dm-snapshot: use bufio prefetch
Date: Sat, 11 Jan 2014 12:32:43 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401111231420.4018@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401111222400.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111228220.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111229150.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111229390.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111230080.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111230330.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111231000.4018@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1401111231000.4018@file01.intranet.prod.int.rdu2.redhat.com>
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

This patch modifies dm-snapshot so that it prefetches the buffers when
loading the exceptions.

The number of buffers read ahead is specified in the DM_PREFETCH_CHUNKS
macro.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap-persistent.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

Index: linux-3.13-rc7/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm-snap-persistent.c	2014-01-11 18:10:34.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm-snap-persistent.c	2014-01-11 18:12:53.000000000 +0100
@@ -18,6 +18,8 @@
 #define DM_MSG_PREFIX "persistent snapshot"
 #define DM_CHUNK_SIZE_DEFAULT_SECTORS 32	/* 16KB */
 
+#define DM_PREFETCH_CHUNKS		12
+
 /*-----------------------------------------------------------------
  * Persistent snapshots, by persistent we mean that the snapshot
  * will survive a reboot.
@@ -496,6 +498,7 @@ static int read_exceptions(struct pstore
 {
 	int r, full = 1;
 	struct dm_bufio_client *client;
+	chunk_t prefetch_area = 0;
 
 	client = dm_bufio_client_create(dm_snap_cow(ps->store->snap)->bdev,
 					ps->store->chunk_size << SECTOR_SHIFT,
@@ -504,6 +507,8 @@ static int read_exceptions(struct pstore
 	if (IS_ERR(client))
 		return PTR_ERR(client);
 
+	dm_bufio_set_minimum_buffers(client, DM_PREFETCH_CHUNKS + 1);
+
 	/*
 	 * Keeping reading chunks and inserting exceptions until
 	 * we find a partially full area.
@@ -511,7 +516,23 @@ static int read_exceptions(struct pstore
 	for (ps->current_area = 0; full; ps->current_area++) {
 		struct dm_buffer *bp;
 		void *area;
-		chunk_t chunk = area_location(ps, ps->current_area);
+		chunk_t chunk;
+
+		if (unlikely(prefetch_area < ps->current_area))
+			prefetch_area = ps->current_area;
+
+		if (DM_PREFETCH_CHUNKS) do {
+			chunk_t pf_chunk = area_location(ps, prefetch_area);
+			if (unlikely(pf_chunk >= dm_bufio_get_device_size(client)))
+				break;
+			if (unlikely(!dm_bufio_prefetch(client, pf_chunk, 1)))
+				break;
+			prefetch_area++;
+			if (unlikely(!prefetch_area))
+				break;
+		} while (prefetch_area <= ps->current_area + DM_PREFETCH_CHUNKS);
+
+		chunk = area_location(ps, ps->current_area);
 
 		area = dm_bufio_read(client, chunk, &bp);
 		if (unlikely(IS_ERR(area))) {
