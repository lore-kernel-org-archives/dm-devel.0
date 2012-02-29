From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 03/13] dm btree remove: remove 2 BUG_ONs from
	__rebalance2 function
Date: Wed, 29 Feb 2012 09:50:07 -0500
Message-ID: <1330527017-28618-4-git-send-email-snitzer@redhat.com>
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

These paranoia checks are no longer needed.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/persistent-data/dm-btree-remove.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index ebd2460..9480fcc 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -234,9 +234,6 @@ static void __rebalance2(struct dm_btree_info *info, struct node *parent,
 		 * Rebalance.
 		 */
 		unsigned target_left = (nr_left + nr_right) / 2;
-		unsigned shift_ = nr_left - target_left;
-		BUG_ON(le32_to_cpu(left->header.max_entries) <= nr_left - shift_);
-		BUG_ON(le32_to_cpu(right->header.max_entries) <= nr_right + shift_);
 		shift(left, right, nr_left - target_left);
 		*key_ptr(parent, r->index) = right->keys[0];
 	}
-- 
1.7.1
