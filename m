From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-writecache: validate block size against
 devices' logical block size
Date: Wed, 15 Apr 2020 11:08:31 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2004151107310.25321@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, David Teigland <teigland@redhat.com>
List-Id: dm-devel.ids

Test if dm-writecache block size is smaller than devices' logical block
size and reject target load in that case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2020-04-15 16:53:35.000000000 +0200
+++ linux-2.6/drivers/md/dm-writecache.c	2020-04-15 17:05:34.000000000 +0200
@@ -2128,6 +2128,12 @@ static int writecache_ctr(struct dm_targ
 		ti->error = "Invalid block size";
 		goto bad;
 	}
+	if (wc->block_size < bdev_logical_block_size(wc->dev->bdev) ||
+	    wc->block_size < bdev_logical_block_size(wc->ssd_dev->bdev)) {
+		r = -EINVAL;
+		ti->error = "Block size is smaller than device logical block size";
+		goto bad;
+	}
 	wc->block_size_bits = __ffs(wc->block_size);
 
 	wc->max_writeback_jobs = MAX_WRITEBACK_JOBS;
