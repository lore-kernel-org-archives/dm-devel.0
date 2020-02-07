From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm-bufio: introduce block_to_sector
Date: Fri, 7 Feb 2020 15:59:58 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2002071559350.24277@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2002071558040.24277@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2002071558040.24277@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-bufio: implement discard

Add functions dm_bufio_issue_discard and dm_bufio_discard_buffers.
dm_bufio_issue_discard sends discard request to the underlying device.
dm_bufio_discard_buffers frees buffers in the range and then calls
dm_bufio_issue_discard.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c    |   50 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dm-bufio.h |   12 +++++++++++
 2 files changed, 62 insertions(+)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2020-02-07 17:14:08.000000000 +0100
+++ linux-2.6/drivers/md/dm-bufio.c	2020-02-07 17:29:42.000000000 +0100
@@ -1338,6 +1338,56 @@ int dm_bufio_issue_flush(struct dm_bufio
 EXPORT_SYMBOL_GPL(dm_bufio_issue_flush);
 
 /*
+ * Use dm-io to send a discard request to flush the device.
+ */
+int dm_bufio_issue_discard(struct dm_bufio_client *c, sector_t block, sector_t count)
+{
+	struct dm_io_request io_req = {
+		.bi_op = REQ_OP_DISCARD,
+		.bi_op_flags = REQ_SYNC,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = NULL,
+		.client = c->dm_io,
+	};
+	struct dm_io_region io_reg = {
+		.bdev = c->bdev,
+		.sector = block_to_sector(c, block),
+		.count = block_to_sector(c, count),
+	};
+
+	BUG_ON(dm_bufio_in_request());
+
+	return dm_io(&io_req, 1, &io_reg, NULL);
+}
+EXPORT_SYMBOL_GPL(dm_bufio_issue_discard);
+
+/*
+ * Free the specified range of buffers. If a buffer is held by other process, it
+ * is not freed. If a buffer is dirty, it is discarded without writeback.
+ * Finally, send the discard request to the device.
+ */
+int dm_bufio_discard_buffers(struct dm_bufio_client *c, sector_t block, sector_t count)
+{
+	sector_t i;
+
+	for (i = block; i < block + count; i++) {
+		struct dm_buffer *b;
+		dm_bufio_lock(c);
+		b = __find(c, i);
+		if (b && likely(!b->hold_count)) {
+			wait_on_bit_io(&b->state, B_READING, TASK_UNINTERRUPTIBLE);
+			wait_on_bit_io(&b->state, B_WRITING, TASK_UNINTERRUPTIBLE);
+			__unlink_buffer(b);
+			__free_buffer_wake(b);
+		}
+		dm_bufio_unlock(c);
+	}
+
+	return dm_bufio_issue_discard(c, block, count);
+}
+EXPORT_SYMBOL_GPL(dm_bufio_discard_buffers);
+
+/*
  * We first delete any other buffer that may be at that new location.
  *
  * Then, we write the buffer to the original location if it was dirty.
Index: linux-2.6/include/linux/dm-bufio.h
===================================================================
--- linux-2.6.orig/include/linux/dm-bufio.h	2020-02-07 17:14:08.000000000 +0100
+++ linux-2.6/include/linux/dm-bufio.h	2020-02-07 17:29:46.000000000 +0100
@@ -126,6 +126,18 @@ int dm_bufio_write_dirty_buffers(struct
 int dm_bufio_issue_flush(struct dm_bufio_client *c);
 
 /*
+ * Send a discard request to the underlying device.
+ */
+int dm_bufio_issue_discard(struct dm_bufio_client *c, sector_t block, sector_t count);
+
+/*
+ * Free the specified range of buffers. If a buffer is held by other process, it
+ * is not freed. If a buffer is dirty, it is discarded without writeback.
+ * Finally, send the discard request to the device.
+ */
+int dm_bufio_discard_buffers(struct dm_bufio_client *c, sector_t block, sector_t count);
+
+/*
  * Like dm_bufio_release but also move the buffer to the new
  * block. dm_bufio_write_dirty_buffers is needed to commit the new block.
  */
