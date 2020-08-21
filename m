From: Ye Bin <yebin10@huawei.com>
Subject: [PATCH 3/4] dm cache metadata: Avoid return pmd->bm wild
	pointer when process with error
Date: Fri, 21 Aug 2020 17:26:50 +0800
Message-ID: <20200821092651.1587859-4-yebin10@huawei.com>
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

Maybe caller will use PTR_ERR as a pointer, it will lead to some strange things.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/md/dm-cache-metadata.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 151aa95775be..af6d4f898e4c 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -537,12 +537,16 @@ static int __create_persistent_data_objects(struct dm_cache_metadata *cmd,
 					  CACHE_MAX_CONCURRENT_LOCKS);
 	if (IS_ERR(cmd->bm)) {
 		DMERR("could not create block manager");
-		return PTR_ERR(cmd->bm);
+		r = PTR_ERR(cmd->bm);
+		cmd->bm = NULL;
+		return r;
 	}
 
 	r = __open_or_format_metadata(cmd, may_format_device);
-	if (r)
+	if (r) {
 		dm_block_manager_destroy(cmd->bm);
+		cmd->bm = NULL;
+	}
 
 	return r;
 }
-- 
2.25.4
