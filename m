From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] block: fix blk_stack_limits() regression due to lcm() change
Date: Mon, 30 Mar 2015 13:39:09 -0400
Message-ID: <20150330173909.GA4836@redhat.com>
References: <1418158984-25546-1-git-send-email-linux@rasmusvillemoes.dk>
 <1418158984-25546-2-git-send-email-linux@rasmusvillemoes.dk>
 <CAMM=eLdw+7zfoufBEBSKhVR5d=g-a-GdzTA4WBgXUcMx=Av91A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMM=eLdw+7zfoufBEBSKhVR5d=g-a-GdzTA4WBgXUcMx=Av91A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-Id: dm-devel.ids

Linux 3.19 commit 69c953c ("lib/lcm.c: lcm(n,0)=lcm(0,n) is 0, not n")
caused blk_stack_limits() to not properly stack queue_limits for stacked
devices (e.g. DM).

Fix this regression by establishing lcm_not_zero() and switching
blk_stack_limits() over to using it.

DM uses blk_set_stacking_limits() to establish the initial top-level
queue_limits that are then built up based on underlying devices' limits
using blk_stack_limits().  In the case of optimal_io_size (io_opt)
blk_set_stacking_limits() establishes a default value of 0.  With commit
69c953c, lcm(0, n) is no longer n, which compromises proper stacking of
the underlying devices' io_opt.

Test:
$ modprobe scsi_debug dev_size_mb=10 num_tgts=1 opt_blks=1536
$ cat /sys/block/sde/queue/optimal_io_size
786432
$ dmsetup create node --table "0 100 linear /dev/sde 0"

Before this fix:
$ cat /sys/block/dm-5/queue/optimal_io_size
0

After this fix:
$ cat /sys/block/dm-5/queue/optimal_io_size
786432

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org # 3.19+
---
 block/blk-settings.c |    6 +++---
 include/linux/lcm.h  |    1 +
 lib/lcm.c            |   11 +++++++++++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 6ed2cbe..12600bf 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -585,7 +585,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 				     b->physical_block_size);
 
 	t->io_min = max(t->io_min, b->io_min);
-	t->io_opt = lcm(t->io_opt, b->io_opt);
+	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
 
 	t->cluster &= b->cluster;
 	t->discard_zeroes_data &= b->discard_zeroes_data;
@@ -616,7 +616,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		    b->raid_partial_stripes_expensive);
 
 	/* Find lowest common alignment_offset */
-	t->alignment_offset = lcm(t->alignment_offset, alignment)
+	t->alignment_offset = lcm_not_zero(t->alignment_offset, alignment)
 		% max(t->physical_block_size, t->io_min);
 
 	/* Verify that new alignment_offset is on a logical block boundary */
@@ -643,7 +643,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 						      b->max_discard_sectors);
 		t->discard_granularity = max(t->discard_granularity,
 					     b->discard_granularity);
-		t->discard_alignment = lcm(t->discard_alignment, alignment) %
+		t->discard_alignment = lcm_not_zero(t->discard_alignment, alignment) %
 			t->discard_granularity;
 	}
 
diff --git a/include/linux/lcm.h b/include/linux/lcm.h
index 7bf01d7..1ce79a7 100644
--- a/include/linux/lcm.h
+++ b/include/linux/lcm.h
@@ -4,5 +4,6 @@
 #include <linux/compiler.h>
 
 unsigned long lcm(unsigned long a, unsigned long b) __attribute_const__;
+unsigned long lcm_not_zero(unsigned long a, unsigned long b) __attribute_const__;
 
 #endif /* _LCM_H */
diff --git a/lib/lcm.c b/lib/lcm.c
index e97dbd5..03d7fcb 100644
--- a/lib/lcm.c
+++ b/lib/lcm.c
@@ -12,3 +12,14 @@ unsigned long lcm(unsigned long a, unsigned long b)
 		return 0;
 }
 EXPORT_SYMBOL_GPL(lcm);
+
+unsigned long lcm_not_zero(unsigned long a, unsigned long b)
+{
+	unsigned long l = lcm(a, b);
+
+	if (l)
+		return l;
+
+	return (b ? : a);
+}
+EXPORT_SYMBOL_GPL(lcm_not_zero);
-- 
1.7.4.4
