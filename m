From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] delete dm_bufio_discard_buffers
Date: Wed, 27 May 2020 07:04:46 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2005270702460.6054@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I suggest to delete dm_bufio_discard_buffers because no one is using it.

If you need it in the future, tell me - and I will optimize it, so that it 
walks the rb-tree of buffers instead of doing block-by-block lookups.

Mikulas



diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index bf289be1ee3a..993e624e506c 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1358,32 +1358,6 @@ int dm_bufio_issue_discard(struct dm_bufio_client *c, sector_t block, sector_t c
 }
 EXPORT_SYMBOL_GPL(dm_bufio_issue_discard);
 
-/*
- * Free the specified range of buffers. If a buffer is held by other process, it
- * is not freed. If a buffer is dirty, it is discarded without writeback.
- * Finally, send the discard request to the device.
- */
-int dm_bufio_discard_buffers(struct dm_bufio_client *c, sector_t block, sector_t count)
-{
-	sector_t i;
-
-	for (i = block; i < block + count; i++) {
-		struct dm_buffer *b;
-		dm_bufio_lock(c);
-		b = __find(c, i);
-		if (b && likely(!b->hold_count)) {
-			wait_on_bit_io(&b->state, B_READING, TASK_UNINTERRUPTIBLE);
-			wait_on_bit_io(&b->state, B_WRITING, TASK_UNINTERRUPTIBLE);
-			__unlink_buffer(b);
-			__free_buffer_wake(b);
-		}
-		dm_bufio_unlock(c);
-	}
-
-	return dm_bufio_issue_discard(c, block, count);
-}
-EXPORT_SYMBOL_GPL(dm_bufio_discard_buffers);
-
 /*
  * We first delete any other buffer that may be at that new location.
  *
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index 07e1f163e299..5ec6bfbde9ae 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -123,13 +123,6 @@ int dm_bufio_issue_flush(struct dm_bufio_client *c);
  */
 int dm_bufio_issue_discard(struct dm_bufio_client *c, sector_t block, sector_t count);
 
-/*
- * Free the specified range of buffers. If a buffer is held by other process, it
- * is not freed. If a buffer is dirty, it is discarded without writeback.
- * Finally, send the discard request to the device.
- */
-int dm_bufio_discard_buffers(struct dm_bufio_client *c, sector_t block, sector_t count);
-
 /*
  * Like dm_bufio_release but also move the buffer to the new
  * block. dm_bufio_write_dirty_buffers is needed to commit the new block.
