From: Ye Bin <yebin10@huawei.com>
Subject: [PATCH 4/4] dm cache metadata: Avoid use-after-free in
	dm_cache_metadata_set_read_only
Date: Fri, 21 Aug 2020 17:26:51 +0800
Message-ID: <20200821092651.1587859-5-yebin10@huawei.com>
References: <20200821092651.1587859-1-yebin10@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200821092651.1587859-1-yebin10@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: yebin10@huawei.com
List-Id: dm-devel.ids

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/md/dm-cache-metadata.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index af6d4f898e4c..397b0fc04c8d 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1761,14 +1761,16 @@ int dm_cache_metadata_all_clean(struct dm_cache_metadata *cmd, bool *result)
 void dm_cache_metadata_set_read_only(struct dm_cache_metadata *cmd)
 {
 	WRITE_LOCK_VOID(cmd);
-	dm_bm_set_read_only(cmd->bm);
+	if (cmd->bm)
+		dm_bm_set_read_only(cmd->bm);
 	WRITE_UNLOCK(cmd);
 }
 
 void dm_cache_metadata_set_read_write(struct dm_cache_metadata *cmd)
 {
 	WRITE_LOCK_VOID(cmd);
-	dm_bm_set_read_write(cmd->bm);
+	if (cmd->bm)
+		dm_bm_set_read_write(cmd->bm);
 	WRITE_UNLOCK(cmd);
 }
 
-- 
2.25.4
