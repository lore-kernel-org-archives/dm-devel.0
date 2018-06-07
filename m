From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-writecache: use low watermark
Date: Thu, 7 Jun 2018 15:58:19 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1806071557500.17754@file01.intranet.prod.int.rdu2.redhat.com>
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

Fix a bug that low watermark was ignored and high watermark was used as
both low and high.

The patch also verifies that high watermark is greater or equal than low
watermark - if this condition is violated, the driver would consume too
much CPU.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2018-06-07 21:21:47.000000000 +0200
+++ linux-2.6/drivers/md/dm-writecache.c	2018-06-07 21:23:21.000000000 +0200
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
