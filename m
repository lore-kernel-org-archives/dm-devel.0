From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/6] dm-bufio: introduce dm_bufio_forget
Date: Mon, 13 Jan 2014 19:12:36 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401131911570.30362@file01.intranet.prod.int.rdu2.redhat.com>
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

Introduce a new function dm_bufio_forget. It frees the given buffer.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   22 ++++++++++++++++++++++
 drivers/md/dm-bufio.h |    7 +++++++
 2 files changed, 29 insertions(+)

Index: linux-3.13-rc7/drivers/md/dm-bufio.c
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm-bufio.c	2014-01-14 00:52:22.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm-bufio.c	2014-01-14 00:52:25.000000000 +0100
@@ -1350,6 +1350,28 @@ retry:
 }
 EXPORT_SYMBOL_GPL(dm_bufio_release_move);
 
+/*
+ * Free the given buffer.
+ *
+ * This is just a hint, if the buffer is in use or dirty, this function
+ * does nothing.
+ */
+void dm_bufio_forget(struct dm_bufio_client *c, sector_t block)
+{
+	struct dm_buffer *b;
+
+	dm_bufio_lock(c);
+
+	b = __find(c, block);
+	if (b && likely(!b->hold_count) && likely(!b->state)) {
+		__unlink_buffer(b);
+		__free_buffer_wake(b);
+	}
+
+	dm_bufio_unlock(c);
+}
+EXPORT_SYMBOL(dm_bufio_forget);
+
 unsigned dm_bufio_get_block_size(struct dm_bufio_client *c)
 {
 	return c->block_size;
Index: linux-3.13-rc7/drivers/md/dm-bufio.h
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm-bufio.h	2014-01-14 00:52:22.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm-bufio.h	2014-01-14 00:52:25.000000000 +0100
@@ -108,6 +108,13 @@ int dm_bufio_issue_flush(struct dm_bufio
  */
 void dm_bufio_release_move(struct dm_buffer *b, sector_t new_block);
 
+/*
+ * Free the given buffer.
+ * This is just a hint, if the buffer is in use or dirty, this function
+ * does nothing.
+ */
+void dm_bufio_forget(struct dm_bufio_client *c, sector_t block);
+
 unsigned dm_bufio_get_block_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_block_number(struct dm_buffer *b);
