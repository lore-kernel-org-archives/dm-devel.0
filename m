From: Shenghui Wang <shhuiw@foxmail.com>
Subject: [PATCH] dm writecache: flush metadata in single commit
	in init_memory
Date: Wed, 24 Oct 2018 18:54:56 +0800
Message-ID: <20181024105456.3204-1-shhuiw@foxmail.com>
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
To: mpatocka@redhat.com, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Do not flush sb ->magic in second commit.

Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
---
 drivers/md/dm-writecache.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index d656bd1799ae..8e9e96a22f68 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1749,6 +1749,8 @@ static int init_memory(struct dm_writecache *wc)
 
 	for (b = 0; b < ARRAY_SIZE(sb(wc)->padding); b++)
 		pmem_assign(sb(wc)->padding[b], cpu_to_le64(0));
+
+	pmem_assign(sb(wc)->magic, cpu_to_le32(MEMORY_SUPERBLOCK_MAGIC));
 	pmem_assign(sb(wc)->version, cpu_to_le32(MEMORY_SUPERBLOCK_VERSION));
 	pmem_assign(sb(wc)->block_size, cpu_to_le32(wc->block_size));
 	pmem_assign(sb(wc)->n_blocks, cpu_to_le64(wc->n_blocks));
@@ -1759,9 +1761,6 @@ static int init_memory(struct dm_writecache *wc)
 
 	writecache_flush_all_metadata(wc);
 	writecache_commit_flushed(wc);
-	pmem_assign(sb(wc)->magic, cpu_to_le32(MEMORY_SUPERBLOCK_MAGIC));
-	writecache_flush_region(wc, &sb(wc)->magic, sizeof sb(wc)->magic);
-	writecache_commit_flushed(wc);
 
 	return 0;
 }
-- 
2.18.0
