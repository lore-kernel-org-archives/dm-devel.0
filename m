From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bufio: check watermark periodically each 30
	seconds
Date: Sun, 30 Apr 2017 17:34:53 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1704301733270.25063@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-bufio checks a watermark when it allocates a new buffer in the function
__bufio_new. However, it doesn't check the watermark when the user changes
the value /sys/module/dm_bufio/parameters/max_cache_size_bytes.

This may result in a problem - if the watermark is high enough so that all
possible buffers are allocated and if the user lowers the value
"max_cache_size_bytes", the watermark will never be checked against the
new value because no new buffer would be allocated.

This patch changes the function __evict_old_buffers so that it checks the
watermark. __evict_old_buffers is called every 30 seconds, so if the user
lowes "max_cache_size_bytes", dm-bufio will react to this change within
30 seconds and decrease memory consumption.

This patch requires the previous patch "dm-bufio: avoid a possible
deadlock due to lock ordering" to be applied. Applying this patch without
the previous patch would result in a deadlock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-bufio.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c
+++ linux-2.6/drivers/md/dm-bufio.c
@@ -1835,9 +1835,17 @@ static void __evict_old_buffers(struct d
 	struct dm_buffer *b, *tmp;
 	unsigned retain_target = get_retain_buffers(c);
 	unsigned count;
+	LIST_HEAD(write_list);
 
 	dm_bufio_lock(c);
 
+	__check_watermark(c, &write_list);
+	if (unlikely(!list_empty(&write_list))) {
+		dm_bufio_unlock(c);
+		__flush_write_list(&write_list);
+		dm_bufio_lock(c);
+	}
+
 	count = c->n_buffers[LIST_CLEAN] + c->n_buffers[LIST_DIRTY];
 	list_for_each_entry_safe_reverse(b, tmp, &c->lru[LIST_CLEAN], lru_list) {
 		if (count <= retain_target)
@@ -1862,6 +1870,8 @@ static void cleanup_old_buffers(void)
 
 	mutex_lock(&dm_bufio_clients_lock);
 
+	__cache_size_refresh();
+
 	list_for_each_entry(c, &dm_bufio_all_clients, client_list)
 		__evict_old_buffers(c, max_age_hz);
 
