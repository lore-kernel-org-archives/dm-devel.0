From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] block: fix infinite loop if the device loses
 discard capability
Date: Tue, 3 Jul 2018 13:34:22 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1807031332250.22443@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

If __blkdev_issue_discard is in progress and a device mapper device is
reloaded with a table that doesn't support discard,
q->limits.max_discard_sectors is set to zero. This results in infinite
loop in __blkdev_issue_discard.

This patch checks if max_discard_sectors is zero and aborts with
-EOPNOTSUPP.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Tested-by: Zdenek Kabelac <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 block/blk-lib.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6/block/blk-lib.c
===================================================================
--- linux-2.6.orig/block/blk-lib.c	2018-06-18 01:08:49.500000000 +0200
+++ linux-2.6/block/blk-lib.c	2018-06-29 20:09:27.670000000 +0200
@@ -68,6 +68,8 @@ int __blkdev_issue_discard(struct block_
 		 */
 		req_sects = min_t(sector_t, nr_sects,
 					q->limits.max_discard_sectors);
+		if (!req_sects)
+			goto fail;
 		if (req_sects > UINT_MAX >> 9)
 			req_sects = UINT_MAX >> 9;
 
@@ -105,6 +107,14 @@ int __blkdev_issue_discard(struct block_
 
 	*biop = bio;
 	return 0;
+
+fail:
+	if (bio) {
+		submit_bio_wait(bio);
+		bio_put(bio);
+	}
+	*biop = NULL;
+	return -EOPNOTSUPP;
 }
 EXPORT_SYMBOL(__blkdev_issue_discard);
 
