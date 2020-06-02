From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/3] dm-bufio: introduce forget_buffer_locked
Date: Tue, 02 Jun 2020 15:34:40 +0200
Message-ID: <20200602133511.805724040@debian-a64.vm>
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
Content-Disposition: inline; filename=dm-bufio-find_next.patch
To: Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Introduce a function forget_buffer_locked that forgets a range of buffers.
It is more efficient than calling forget_buffer in a loop.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c    |   60 +++++++++++++++++++++++++++++++++++++++++++----
 include/linux/dm-bufio.h |    7 +++++
 2 files changed, 63 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2020-06-02 14:26:32.000000000 +0200
+++ linux-2.6/drivers/md/dm-bufio.c	2020-06-02 15:09:11.000000000 +0200
@@ -262,6 +262,29 @@ static struct dm_buffer *__find(struct d
 	return NULL;
 }
 
+static struct dm_buffer *__find_next(struct dm_bufio_client *c, sector_t block)
+{
+	struct rb_node *n = c->buffer_tree.rb_node;
+	struct dm_buffer *b;
+	struct dm_buffer *best = NULL;
+
+	while (n) {
+		b = container_of(n, struct dm_buffer, node);
+
+		if (b->block == block)
+			return b;
+
+		if (block <= b->block) {
+			n = n->rb_left;
+			best = b;
+		} else {
+			n = n->rb_right;
+		}
+	}
+
+	return best;
+}
+
 static void __insert(struct dm_bufio_client *c, struct dm_buffer *b)
 {
 	struct rb_node **new = &c->buffer_tree.rb_node, *parent = NULL;
@@ -1460,6 +1483,14 @@ retry:
 }
 EXPORT_SYMBOL_GPL(dm_bufio_release_move);
 
+static void forget_buffer_locked(struct dm_buffer *b)
+{
+	if (likely(!b->hold_count) && likely(!b->state)) {
+		__unlink_buffer(b);
+		__free_buffer_wake(b);
+	}
+}
+
 /*
  * Free the given buffer.
  *
@@ -1473,15 +1504,36 @@ void dm_bufio_forget(struct dm_bufio_cli
 	dm_bufio_lock(c);
 
 	b = __find(c, block);
-	if (b && likely(!b->hold_count) && likely(!b->state)) {
-		__unlink_buffer(b);
-		__free_buffer_wake(b);
-	}
+	if (b)
+		forget_buffer_locked(b);
 
 	dm_bufio_unlock(c);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_forget);
 
+void dm_bufio_forget_buffers(struct dm_bufio_client *c, sector_t block, sector_t n_blocks)
+{
+	struct dm_buffer *b;
+	sector_t end_block = block + n_blocks;
+
+	while (block < end_block) {
+		dm_bufio_lock(c);
+
+		b = __find_next(c, block);
+		if (b) {
+			block = b->block + 1;
+			forget_buffer_locked(b);
+		}
+
+		dm_bufio_unlock(c);
+
+		if (!b)
+			break;
+	}
+
+}
+EXPORT_SYMBOL_GPL(dm_bufio_forget_buffers);
+
 void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned n)
 {
 	c->minimum_buffers = n;
Index: linux-2.6/include/linux/dm-bufio.h
===================================================================
--- linux-2.6.orig/include/linux/dm-bufio.h	2020-06-02 13:27:14.000000000 +0200
+++ linux-2.6/include/linux/dm-bufio.h	2020-06-02 15:04:55.000000000 +0200
@@ -144,6 +144,13 @@ void dm_bufio_release_move(struct dm_buf
 void dm_bufio_forget(struct dm_bufio_client *c, sector_t block);
 
 /*
+ * Free the given range of buffers.
+ * This is just a hint, if the buffer is in use or dirty, this function
+ * does nothing.
+ */
+void dm_bufio_forget_buffers(struct dm_bufio_client *c, sector_t block, sector_t n_blocks);
+
+/*
  * Set the minimum number of buffers before cleanup happens.
  */
 void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned n);
