From: Dennis Yang <dennisyang@qnap.com>
Subject: [PATCH] dm thin metadata: THIN_MAX_CONCURRENT_LOCKS should be 6
Date: Tue, 12 Dec 2017 18:21:40 +0800
Message-ID: <20171212102140.22082-1-dennisyang@qnap.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Dennis Yang <dennisyang@qnap.com>
List-Id: dm-devel.ids

For btree removal, there is a corner case that a single thread
could takes 6 locks which is more than THIN_MAX_CONCURRENT_LOCKS(5)
and leads to deadlock.

A btree removal might eventually call
rebalance_children()->rebalance3() to rebalance entries of three
neighbor child nodes when shadow_spine has already acquired two
write locks. In rebalance3(), it tries to shadow and acquire the
write locks of all three child nodes. However, shadowing a child
node requires acquiring a read lock of the original child node and
a write lock of the new block. Although the read lock will be
released after block shadowing, shadowing the third child node
in rebalance3() could still take the sixth lock.
(2 write locks for shadow_spine +
 2 write locks for the first two child nodes's shadow +
 1 write lock for the last child node's shadow +
 1 read lock for the last child node)

Signed-off-by: Dennis Yang <dennisyang@qnap.com>
---
 drivers/md/dm-thin-metadata.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index d31d18d9727c..a21a1110df05 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -80,10 +80,11 @@
 #define SECTOR_TO_BLOCK_SHIFT 3
 
 /*
- *  3 for btree insert +
- *  2 for btree lookup used within space map
+ * For btree remove,
+ * 2 for shadow spine + 
+ * 4 for rebalance 3 child node    
  */
-#define THIN_MAX_CONCURRENT_LOCKS 5
+#define THIN_MAX_CONCURRENT_LOCKS 6
 
 /* This should be plenty */
 #define SPACE_MAP_ROOT_SIZE 128
-- 
2.14.2
