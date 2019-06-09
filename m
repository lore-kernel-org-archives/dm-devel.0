From: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Subject: [PATCH V2] dm space map common: remove the redundancy
	check for the sm_find_free's return value
Date: Sun, 9 Jun 2019 15:52:00 +0800
Message-ID: <1560066720-94807-1-git-send-email-zhangxiaoxu5@huawei.com>
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
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com, zhangxiaoxu5@huawei.com
List-Id: dm-devel.ids

The function sm_find_free just return -ENOSPC and 0.
So, remove the redundancy check.

Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
---
 drivers/md/persistent-data/dm-space-map-common.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index b8a6218..bd68f6f 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -369,10 +369,6 @@ int sm_ll_find_free_block(struct ll_disk *ll, dm_block_t begin,
 			 */
 			dm_tm_unlock(ll->tm, blk);
 			continue;
-
-		} else if (r < 0) {
-			dm_tm_unlock(ll->tm, blk);
-			return r;
 		}
 
 		dm_tm_unlock(ll->tm, blk);
-- 
2.7.4
