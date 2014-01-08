From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 1/2] dm space map common: make sure new
	space is used during extend
Date: Wed,  8 Jan 2014 14:20:59 -0500
Message-ID: <1389208860-18068-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
Cc: ejt@redhat.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

When extending a low level space map we should update nr_blocks at
the start so the new space is used for the index entries.

Otherwise extend can fail, e.g.: sm_metadata_extend call sequence
that fails:
 -> sm_ll_extend
    -> dm_tm_new_block -> dm_sm_new_block -> sm_bootstrap_new_block
    => returns -ENOSPC because smm->begin == smm->ll.nr_blocks

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/md/persistent-data/dm-space-map-common.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index 466a60b..aacbe70 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -245,6 +245,10 @@ int sm_ll_extend(struct ll_disk *ll, dm_block_t extra_blocks)
 		return -EINVAL;
 	}
 
+	/*
+	 * We need to set this before the dm_tm_new_block() call below.
+	 */
+	ll->nr_blocks = nr_blocks;
 	for (i = old_blocks; i < blocks; i++) {
 		struct dm_block *b;
 		struct disk_index_entry idx;
@@ -252,6 +256,7 @@ int sm_ll_extend(struct ll_disk *ll, dm_block_t extra_blocks)
 		r = dm_tm_new_block(ll->tm, &dm_sm_bitmap_validator, &b);
 		if (r < 0)
 			return r;
+
 		idx.blocknr = cpu_to_le64(dm_block_location(b));
 
 		r = dm_tm_unlock(ll->tm, b);
@@ -266,7 +271,6 @@ int sm_ll_extend(struct ll_disk *ll, dm_block_t extra_blocks)
 			return r;
 	}
 
-	ll->nr_blocks = nr_blocks;
 	return 0;
 }
 
-- 
1.8.1.4
