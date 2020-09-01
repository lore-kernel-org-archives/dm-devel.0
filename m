From: Ye Bin <yebin10@huawei.com>
Subject: [PATCH v2 2/3] dm thin metadata: Avoid return pmd->bm
	wild pointer when process with error
Date: Tue, 1 Sep 2020 14:25:43 +0800
Message-ID: <20200901062544.827277-3-yebin10@huawei.com>
References: <20200901062544.827277-1-yebin10@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200901062544.827277-1-yebin10@huawei.com>
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
Cc: Ye Bin <yebin10@huawei.com>
List-Id: dm-devel.ids

Maybe caller will use PTR_ERR as a pointer, it will lead to some strange
things.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/md/dm-thin-metadata.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 76b6b323bf4b..ddb7f1f0bc48 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -739,12 +739,16 @@ static int __create_persistent_data_objects(struct dm_pool_metadata *pmd, bool f
 					  THIN_MAX_CONCURRENT_LOCKS);
 	if (IS_ERR(pmd->bm)) {
 		DMERR("could not create block manager");
-		return PTR_ERR(pmd->bm);
+		r = PTR_ERR(pmd->bm);
+		pmd->bm = NULL;
+		return r;
 	}
 
 	r = __open_or_format_metadata(pmd, format_device);
-	if (r)
+	if (r) {
 		dm_block_manager_destroy(pmd->bm);
+		pmd->bm = NULL;
+	}
 
 	return r;
 }
-- 
2.25.4
