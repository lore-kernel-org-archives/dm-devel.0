From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/5] dm-bufio: call adjust_total_allocated from
	__link_buffer and __unlink_buffer
Date: Thu, 12 Sep 2019 10:44:44 +0200
Message-ID: <20190912084545.276409400@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline;
	filename=dm-bufio-call-adjust_total_allocated-from-__link_buffer-and-__unlink_buffer.patch
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

Move the call to adjust_total_allocated to __link_buffer and
__unlink_buffer, so that only used buffers are counted. Reserved buffers
are not.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2019-09-10 09:35:40.000000000 +0200
+++ linux-2.6/drivers/md/dm-bufio.c	2019-09-10 16:36:06.000000000 +0200
@@ -432,8 +432,6 @@ static struct dm_buffer *alloc_buffer(st
 		return NULL;
 	}
 
-	adjust_total_allocated(b->data_mode, (long)c->block_size);
-
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
 	b->stack_len = 0;
 #endif
@@ -447,8 +445,6 @@ static void free_buffer(struct dm_buffer
 {
 	struct dm_bufio_client *c = b->c;
 
-	adjust_total_allocated(b->data_mode, -(long)c->block_size);
-
 	free_buffer_data(c, b->data, b->data_mode);
 	kmem_cache_free(c->slab_buffer, b);
 }
@@ -466,6 +462,8 @@ static void __link_buffer(struct dm_buff
 	list_add(&b->lru_list, &c->lru[dirty]);
 	__insert(b->c, b);
 	b->last_accessed = jiffies;
+
+	adjust_total_allocated(b->data_mode, (long)c->block_size);
 }
 
 /*
@@ -480,6 +478,8 @@ static void __unlink_buffer(struct dm_bu
 	c->n_buffers[b->list_mode]--;
 	__remove(b->c, b);
 	list_del(&b->lru_list);
+
+	adjust_total_allocated(b->data_mode, -(long)c->block_size);
 }
 
 /*
