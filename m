From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-verity: code cleanup - use __ffs and __fls
Date: Fri, 28 Jun 2013 14:46:30 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1306281446010.30356@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1306281100050.16714@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1306281100050.16714@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

dm-verity: code cleanup - use __ffs and __fls

This patch is a small code cleanup for dm-verity. In Linux kernel there
are functions __ffs and __fls which don't add one to the result like libc
functions ffs and fls. This patch changes ffs to __ffs and fls to __fls.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-verity.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-3.9.8-fast/drivers/md/dm-verity.c
===================================================================
--- linux-3.9.8-fast.orig/drivers/md/dm-verity.c	2013-06-28 18:16:02.000000000 +0200
+++ linux-3.9.8-fast/drivers/md/dm-verity.c	2013-06-28 18:52:31.000000000 +0200
@@ -451,7 +451,7 @@ static void verity_prefetch_io(struct wo
 				goto no_prefetch_cluster;
 
 			if (unlikely(cluster & (cluster - 1)))
-				cluster = 1 << (fls(cluster) - 1);
+				cluster = 1 << __fls(cluster);
 
 			hash_block_start &= ~(sector_t)(cluster - 1);
 			hash_block_end |= cluster - 1;
@@ -723,7 +723,7 @@ static int verity_ctr(struct dm_target *
 		r = -EINVAL;
 		goto bad;
 	}
-	v->data_dev_block_bits = ffs(num) - 1;
+	v->data_dev_block_bits = __ffs(num);
 
 	if (sscanf(argv[4], "%u%c", &num, &dummy) != 1 ||
 	    !num || (num & (num - 1)) ||
@@ -733,7 +733,7 @@ static int verity_ctr(struct dm_target *
 		r = -EINVAL;
 		goto bad;
 	}
-	v->hash_dev_block_bits = ffs(num) - 1;
+	v->hash_dev_block_bits = __ffs(num);
 
 	if (sscanf(argv[5], "%llu%c", &num_ll, &dummy) != 1 ||
 	    (sector_t)(num_ll << (v->data_dev_block_bits - SECTOR_SHIFT))
@@ -812,7 +812,7 @@ static int verity_ctr(struct dm_target *
 	}
 
 	v->hash_per_block_bits =
-		fls((1 << v->hash_dev_block_bits) / v->digest_size) - 1;
+		__fls((1 << v->hash_dev_block_bits) / v->digest_size);
 
 	v->levels = 0;
 	if (v->data_blocks)
