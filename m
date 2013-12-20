From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 08/20] dm thin: return error from
	alloc_data_block if pool is not in write mode
Date: Fri, 20 Dec 2013 18:37:21 -0500
Message-ID: <1387582653-13647-9-git-send-email-snitzer@redhat.com>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
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

From: Joe Thornber <ejt@redhat.com>

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 70b02fd..b721d7a 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -927,6 +927,9 @@ static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 	if (pool->no_free_space)
 		return -ENOSPC;
 
+	if (get_pool_mode(pool) != PM_WRITE)
+		return -EINVAL;
+
 	r = dm_pool_get_free_block_count(pool->pmd, &free_blocks);
 	if (r)
 		return r;
-- 
1.8.1.4
