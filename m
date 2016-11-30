From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH] dm-persistent-data: free sm_metadata on failed
	create
Date: Wed, 30 Nov 2016 17:56:14 -0600
Message-ID: <1480550174-8675-1-git-send-email-bmarzins@redhat.com>
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
Cc: Edward Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

In dm_sm_metadata_create we temporarily change the dm_space_map
operations from ops, whose destroy function deallocates the
sm_metadata, to bootstrap_ops, whose destroy function doesn't. If we
fail in dm_ll_new_metadata or sm_ll_extend, we exit back to
dm_tm_create_internal, which calls dm_sm_destroy with the intention
of freeing the sm_metadata, but it doesn't.

This patch sets the dm_space_map operations back to ops if
dm_sm_metadata_create fails when it is set to bootstrap_ops.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/persistent-data/dm-space-map-metadata.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index 7e44005..20557e2 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -775,17 +775,15 @@ int dm_sm_metadata_create(struct dm_space_map *sm,
 	memcpy(&smm->sm, &bootstrap_ops, sizeof(smm->sm));
 
 	r = sm_ll_new_metadata(&smm->ll, tm);
+	if (!r) {
+		if (nr_blocks > DM_SM_METADATA_MAX_BLOCKS)
+			nr_blocks = DM_SM_METADATA_MAX_BLOCKS;
+		r = sm_ll_extend(&smm->ll, nr_blocks);
+	}
+	memcpy(&smm->sm, &ops, sizeof(smm->sm));
 	if (r)
 		return r;
 
-	if (nr_blocks > DM_SM_METADATA_MAX_BLOCKS)
-		nr_blocks = DM_SM_METADATA_MAX_BLOCKS;
-	r = sm_ll_extend(&smm->ll, nr_blocks);
-	if (r)
-		return r;
-
-	memcpy(&smm->sm, &ops, sizeof(smm->sm));
-
 	/*
 	 * Now we need to update the newly created data structures with the
 	 * allocated blocks that they were built from.
-- 
2.1.0
