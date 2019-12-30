From: Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: [PATCH] dm-thin: Fix trivial error in comment
	documentation
Date: Mon, 30 Dec 2019 10:54:32 +0800
Message-ID: <1577674472-14110-1-git-send-email-jefflexu@linux.alibaba.com>
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
To: snitzer@redhat.com, dm-devel@redhat.com, agk@redhat.com
Cc: joseph.qi@linux.alibaba.com
List-Id: dm-devel.ids

It's a trivial error in comment documentation, but it may be
confusing to new developers. So just fix it.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/md/dm-thin-metadata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index b88d6d7..df8b804 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -28,7 +28,7 @@
  *
  * - A hierarchical btree, with 2 levels which effectively maps (thin
  *   dev id, virtual block) -> block_time.  Block time is a 64-bit
- *   field holding the time in the low 24 bits, and block in the top 48
+ *   field holding the time in the low 24 bits, and block in the top 40
  *   bits.
  *
  * BTrees consist solely of btree_nodes, that fill a block.  Some are
-- 
1.8.3.1
