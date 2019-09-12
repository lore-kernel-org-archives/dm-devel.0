From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/5] dm-bufio: refactor adjust_total_allocated
Date: Thu, 12 Sep 2019 10:44:45 +0200
Message-ID: <20190912084546.557435880@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline;
	filename=dm-bufio-refactor-adjust_total_allocated.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martijn Coenen <maco@android.com>, Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: dariofreni@google.com, jiyong@google.com, dm-devel@redhat.com, maco@google.com, Mikulas Patocka <mpatocka@redhat.com>, kernel-team@android.com
List-Id: dm-devel.ids

Refactor adjust_total_allocated, so that it takes a bool argument
indicating if it should add or subtract the buffer size.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2019-09-10 16:38:03.000000000 +0200
+++ linux-2.6/drivers/md/dm-bufio.c	2019-09-10 16:38:41.000000000 +0200
@@ -286,14 +286,22 @@ static void __remove(struct dm_bufio_cli
 
 /*----------------------------------------------------------------*/
 
-static void adjust_total_allocated(unsigned char data_mode, long diff)
+static void adjust_total_allocated(struct dm_buffer *b, bool unlink)
 {
+	unsigned char data_mode;
+	long diff;
+
 	static unsigned long * const class_ptr[DATA_MODE_LIMIT] = {
 		&dm_bufio_allocated_kmem_cache,
 		&dm_bufio_allocated_get_free_pages,
 		&dm_bufio_allocated_vmalloc,
 	};
 
+	data_mode = b->data_mode;
+	diff = (long)b->c->block_size;
+	if (unlink)
+		diff = -diff;
+
 	spin_lock(&param_spinlock);
 
 	*class_ptr[data_mode] += diff;
@@ -463,7 +471,7 @@ static void __link_buffer(struct dm_buff
 	__insert(b->c, b);
 	b->last_accessed = jiffies;
 
-	adjust_total_allocated(b->data_mode, (long)c->block_size);
+	adjust_total_allocated(b, false);
 }
 
 /*
@@ -479,7 +487,7 @@ static void __unlink_buffer(struct dm_bu
 	__remove(b->c, b);
 	list_del(&b->lru_list);
 
-	adjust_total_allocated(b->data_mode, -(long)c->block_size);
+	adjust_total_allocated(b, true);
 }
 
 /*
