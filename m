From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 3/4] [dm-cache] Switch to new dm_bm_flush()
	interface.
Date: Thu, 27 Mar 2014 14:13:22 +0000
Message-ID: <1395929603-14604-4-git-send-email-ejt@redhat.com>
References: <1395929603-14604-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1395929603-14604-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

---
 drivers/md/dm-cache-metadata.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 9ef0752..3e7fd7d 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -530,8 +530,9 @@ static int __begin_transaction_flags(struct dm_cache_metadata *cmd,
 	disk_super = dm_block_data(sblock);
 	update_flags(disk_super, mutator);
 	read_superblock_fields(cmd, disk_super);
+	dm_bm_unlock(sblock);
 
-	return dm_bm_flush_and_unlock(cmd->bm, sblock);
+	return dm_bm_flush(cmd->bm);
 }
 
 static int __begin_transaction(struct dm_cache_metadata *cmd)
-- 
1.7.10.4
