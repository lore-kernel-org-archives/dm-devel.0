From: Brian Foster <bfoster@redhat.com>
Subject: [RFC v2 PATCH 10/10] xfs: use contiguous bdev reservation for file preallocation
Date: Tue, 12 Apr 2016 12:42:53 -0400
Message-ID: <1460479373-63317-11-git-send-email-bfoster@redhat.com>
References: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

The block device reservation that occurs as part of transaction
reservation uses a worst case algorithm to determine the amount of
reservation required to satisfy the transaction. This means that one
bdev (i.e., device-mapper) block is reserved per required filesystem
block, even though the former block size is likely much larger than the
latter.

Worst case reservation is required in most cases because, from the
perspective of the transaction, block allocation can occur throughout
the block address space. This is unnecessary for some operations where
more context is available, however. xfs_alloc_file_space() is one such
case. It calls xfs_bmapi_write() in a loop and once per transaction.
Since it also passes nmap == 1, each call maps a single extent and thus
allocates contiguous blocks. Based on that, the bdev reservation can be
reduced from the worst case 1-1 mapping to a more optimal 1-N mapping of
dm blocks to fs blocks (e.g., one dm block can cover many fs blocks).

Update xfs_alloc_file_space() to bypass transaction based bdev
reservation. Instead, open-code the bdev reservation using the more
optimal contiguous reservation value. This allows fallocate requests to
consume just about all of the available space in a thin volume without
premature ENOSPC errors.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 3b63098..c2e1215 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -40,6 +40,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_log.h"
+#include "xfs_thin.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -1035,9 +1036,11 @@ xfs_alloc_file_space(
 		}
 
 		/*
-		 * Allocate and setup the transaction.
+		 * Allocate and setup the transaction. The noblkres flags tells
+		 * the reservation infrastructure to skip bdev reservation.
 		 */
 		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
+		tp->t_flags |= XFS_TRANS_NOBLKRES;
 		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
 					  resblks, resrtextents);
 		/*
@@ -1051,6 +1054,30 @@ xfs_alloc_file_space(
 			xfs_trans_cancel(tp);
 			break;
 		}
+
+		/*
+		 * We disabled the transaction bdev reservation because the
+		 * trans infrastructure uses a worst case reservation. Since we
+		 * call xfs_bmapi_write() one mapping at a time, we can assume
+		 * the allocated blocks will be contiguous and thus can use a
+		 * more optimal reservation value. Acquire the reservation here
+		 * and attach it to the transaction.
+		 *
+		 * XXX: Need to take apart data and metadata block parts of res
+		 * (see XFS_DIOSTRAT_SPACE_RES()). The latter still needs
+		 * worst-case.
+		 */
+		if (mp->m_thin_res) {
+			sector_t	res = xfs_fsb_res(mp, resblks, true);
+
+			error = xfs_thin_reserve(mp, res);
+			if (error) {
+				xfs_trans_cancel(tp);
+				break;
+			}
+			tp->t_blk_thin_res = res;
+		}
+
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks,
 						      0, quota_flag);
-- 
2.4.11

