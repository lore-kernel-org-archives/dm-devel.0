From: Monty Pavel <monty_pavel@sina.com>
Subject: [PATCH] dm thin: superblock may write succeed before
 other metadata blocks because of wirting metadata in async mode.
Date: Mon, 21 May 2018 20:53:36 -0400
Message-ID: <17806.5268708908$1526895673@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


If dm_bufio_write_dirty_buffers func is called by __commit_transaction
func and power loss happens during executing it, coincidencely
superblock wrote correctly but some metadata blocks didn't. The reason
is we write all metadata in async mode. We can guarantee that we send
superblock after other blocks but we cannot guarantee that superblock
write completely early than other blocks.
So, We need to commit other metadata blocks before change superblock.

Signed-off-by: Monty Pavel <monty_pavel@sina.com>
---
 drivers/md/dm-thin-metadata.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 36ef284..897d7d6 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -813,6 +813,14 @@ static int __commit_transaction(struct dm_pool_metadata *pmd)
 	if (r)
 		return r;
 
+	r = dm_tm_commit(pmd->tm, sblock);
+	if (r)
+		return r;
+
+	r = superblock_lock(pmd, &sblock);
+	if (r)
+		return r;
+
 	disk_super = dm_block_data(sblock);
 	disk_super->time = cpu_to_le32(pmd->time);
 	disk_super->data_mapping_root = cpu_to_le64(pmd->root);
-- 
1.7.1
