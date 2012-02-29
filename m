From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 06/13] dm space map: remove entries from the
	ref_count tree if no longer needed
Date: Wed, 29 Feb 2012 09:50:10 -0500
Message-ID: <1330527017-28618-7-git-send-email-snitzer@redhat.com>
References: <1330527017-28618-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1330527017-28618-1-git-send-email-snitzer@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Reference counts are stored in two places: a bitmap if the ref_count
is below 3, or a btree of uint32_t if 3 or above.

When a ref_count that was above 3 drops below we can remove it from
the tree and save some metadata space.  This removal was commented out
before because I was unsure why this was causing under populated btree
nodes.  An earlier patch fixed this issue.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/persistent-data/dm-space-map-common.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index df2494c..ff3beed 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -405,8 +405,6 @@ int sm_ll_insert(struct ll_disk *ll, dm_block_t b,
 		if (r < 0)
 			return r;
 
-#if 0
-		/* FIXME: dm_btree_remove doesn't handle this yet */
 		if (old > 2) {
 			r = dm_btree_remove(&ll->ref_count_info,
 					    ll->ref_count_root,
@@ -414,7 +412,6 @@ int sm_ll_insert(struct ll_disk *ll, dm_block_t b,
 			if (r)
 				return r;
 		}
-#endif
 
 	} else {
 		__le32 le_rc = cpu_to_le32(ref_count);
-- 
1.7.1
