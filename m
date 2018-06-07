From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v2] dm-writecache: use low watermark
Date: Thu, 7 Jun 2018 18:51:09 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1806071848300.22676@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1806071557500.17754@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1806071557500.17754@file01.intranet.prod.int.rdu2.redhat.com>
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

This is a second version of the patche - it changes the condition in 
writecache_pop_from_freelist, to avoid wakeup storm if wc->writeback_size 
is greater than wc->freelist_low_watermark-wc->freelist_high_watermark.


From: Mikulas Patocka <mpatocka@redhat.com>

Fix a bug that low watermark was ignored and high watermark was used as
both low and high.

The patch also verifies that high watermark is greater or equal than low
watermark - if this condition is violated, the driver would consume too
much CPU.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2018-06-07 22:37:48.000000000 +0200
+++ linux-2.6/drivers/md/dm-writecache.c	2018-06-07 22:38:18.000000000 +0200
@@ -644,7 +644,7 @@ static struct wc_entry *writecache_pop_f
 		list_del(&e->lru);
 	}
 	wc->freelist_size--;
-	if (unlikely(wc->freelist_size <= wc->freelist_high_watermark))
+	if (unlikely(wc->freelist_size + wc->writeback_size <= wc->freelist_high_watermark))
 		queue_work(wc->writeback_wq, &wc->writeback_work);
 
 	return e;
@@ -1590,7 +1590,7 @@ restart:
 	wbl.size = 0;
 	while (!list_empty(&wc->lru) &&
 	       (wc->writeback_all ||
-		wc->freelist_size + wc->writeback_size <= wc->freelist_high_watermark)) {
+		wc->freelist_size + wc->writeback_size <= wc->freelist_low_watermark)) {
 
 		n_walked++;
 		if (unlikely(n_walked > WRITEBACK_LATENCY) &&
@@ -2033,6 +2033,12 @@ invalid_optional:
 		}
 	}
 
+	if (high_wm_percent < low_wm_percent) {
+		r = -EINVAL;
+		ti->error = "High watermark must be greater or equal than low watermark";
+		goto bad;
+	}
+
 	if (!WC_MODE_PMEM(wc)) {
 		struct dm_io_region region;
 		struct dm_io_request req;
