From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/7] dm-bufio: introduce
	dm_bufio_set_minimum_buffers
Date: Sat, 11 Jan 2014 12:30:03 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401111229390.4018@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401111222400.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111228220.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111229150.4018@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1401111229150.4018@file01.intranet.prod.int.rdu2.redhat.com>
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

The function dm_bufio_set_minimum_buffers sets the number of buffers
before freeing happens. dm-bufio may hold more buffers if enough memory is
available.

There is no guarantee that the specified number of buffers will be
available - if you need a guarantee, use the argument reserved_buffers for
dm_bufio_client_create.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   14 ++++++++++++--
 drivers/md/dm-bufio.h |    5 +++++
 2 files changed, 17 insertions(+), 2 deletions(-)

Index: linux-3.13-rc7/drivers/md/dm-bufio.c
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm-bufio.c	2014-01-11 18:05:24.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm-bufio.c	2014-01-11 18:09:01.000000000 +0100
@@ -104,6 +104,8 @@ struct dm_bufio_client {
 	struct list_head reserved_buffers;
 	unsigned need_reserved_buffers;
 
+	unsigned minimum_buffers;
+
 	struct hlist_head *cache_hash;
 	wait_queue_head_t free_buffer_wait;
 
@@ -861,8 +863,8 @@ static void __get_memory_limit(struct dm
 	buffers = dm_bufio_cache_size_per_client >>
 		  (c->sectors_per_block_bits + SECTOR_SHIFT);
 
-	if (buffers < DM_BUFIO_MIN_BUFFERS)
-		buffers = DM_BUFIO_MIN_BUFFERS;
+	if (buffers < c->minimum_buffers)
+		buffers = c->minimum_buffers;
 
 	*limit_buffers = buffers;
 	*threshold_buffers = buffers * DM_BUFIO_WRITEBACK_PERCENT / 100;
@@ -1376,6 +1378,12 @@ void dm_bufio_forget(struct dm_bufio_cli
 }
 EXPORT_SYMBOL(dm_bufio_forget);
 
+void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned n)
+{
+	c->minimum_buffers = n;
+}
+EXPORT_SYMBOL(dm_bufio_set_minimum_buffers);
+
 unsigned dm_bufio_get_block_size(struct dm_bufio_client *c)
 {
 	return c->block_size;
@@ -1572,6 +1580,8 @@ struct dm_bufio_client *dm_bufio_client_
 	INIT_LIST_HEAD(&c->reserved_buffers);
 	c->need_reserved_buffers = reserved_buffers;
 
+	c->minimum_buffers = DM_BUFIO_MIN_BUFFERS;
+
 	init_waitqueue_head(&c->free_buffer_wait);
 	c->async_write_error = 0;
 
Index: linux-3.13-rc7/drivers/md/dm-bufio.h
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm-bufio.h	2014-01-11 18:06:53.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm-bufio.h	2014-01-11 18:09:13.000000000 +0100
@@ -115,6 +115,11 @@ void dm_bufio_release_move(struct dm_buf
  */
 void dm_bufio_forget(struct dm_bufio_client *c, sector_t block);
 
+/*
+ * Set the minimum number of buffers before cleanup happens.
+ */
+void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned n);
+
 unsigned dm_bufio_get_block_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_block_number(struct dm_buffer *b);
