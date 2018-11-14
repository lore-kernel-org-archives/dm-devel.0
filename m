From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] fix infinite loop in __blkdev_issue_discard
Date: Wed, 14 Nov 2018 12:52:52 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1811141240050.18040@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Mariusz Dabrowski <mariusz.dabrowski@intel.com>, linux-block@vger.kernel.org, Xiao Ni <xni@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

The "min_t(unsigned int" macro truncates both arguments to unsigned int. 
So, if we are running discard on a very big device with 2^32 or more 
sectors, the truncation may produce zero, resulting in infinite loop.

This patch fixes the infinite loop in the lvm test lvcreate-large-raid.sh

BTW. the patch 744889b7cbb56a64f957e65ade7cb65fe3f35714 that was committed 
between v4.19-rc8 and v4.19 also breaks discard by truncating sector_t to 
unsigned int (but it won't result in an infinite loop, it will result in 
an error instead). Should it be pulled out from the 4.19 long term branch? 
Or should we backport all the subsequent patches on the top of it?

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Fixes: ba5d73851e71 ("block: cleanup __blkdev_issue_discard()")
Fixes: 744889b7cbb5 ("block: don't deal with discard limit in blkdev_issue_discard()")
Cc: stable@vger.kernel.org	# v4.19

---
 block/blk-lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/block/blk-lib.c
===================================================================
--- linux-2.6.orig/block/blk-lib.c	2018-11-14 18:25:28.000000000 +0100
+++ linux-2.6/block/blk-lib.c	2018-11-14 18:33:04.000000000 +0100
@@ -55,7 +55,7 @@ int __blkdev_issue_discard(struct block_
 		return -EINVAL;
 
 	while (nr_sects) {
-		unsigned int req_sects = min_t(unsigned int, nr_sects,
+		unsigned int req_sects = min_t(sector_t, nr_sects,
 				bio_allowed_max_sectors(q));
 
 		bio = blk_next_bio(bio, 0, gfp_mask);
