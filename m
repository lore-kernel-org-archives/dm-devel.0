From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 2/2] dm space map metadata: fix
	extending the space map
Date: Wed,  8 Jan 2014 14:21:00 -0500
Message-ID: <1389208860-18068-2-git-send-email-snitzer@redhat.com>
References: <1389208860-18068-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1389208860-18068-1-git-send-email-snitzer@redhat.com>
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

When extending a metadata space map we should do the first commit whilst
still in bootstrap mode -- a mode where all blocks get allocated in the
new area.

That way the commit overhead is allocated from the newly added space.
Otherwise we risk running out of space.

With this fix, and the previous commit "dm space map common: make sure
new space is used during extend", the following device mapper testsuite
test passes:
 dmtest run --suite thin-provisioning -n /resize_metadata_no_io/

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/md/persistent-data/dm-space-map-metadata.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index e930844..bfbfe03 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -608,20 +608,28 @@ static int sm_metadata_extend(struct dm_space_map *sm, dm_block_t extra_blocks)
 	 * Flick into a mode where all blocks get allocated in the new area.
 	 */
 	smm->begin = old_len;
-	memcpy(&smm->sm, &bootstrap_ops, sizeof(smm->sm));
+	memcpy(sm, &bootstrap_ops, sizeof(*sm));
 
 	/*
 	 * Extend.
 	 */
 	r = sm_ll_extend(&smm->ll, extra_blocks);
+	if (r)
+		goto out;
+
+	for (i = old_len; !r && i < smm->begin; i++) {
+		r = sm_ll_inc(&smm->ll, i, &ev);
+		if (r)
+			goto out;
+	}
 
+	r = sm_metadata_commit(sm);
+
+out:
 	/*
 	 * Switch back to normal behaviour.
 	 */
-	memcpy(&smm->sm, &ops, sizeof(smm->sm));
-	for (i = old_len; !r && i < smm->begin; i++)
-		r = sm_ll_inc(&smm->ll, i, &ev);
-
+	memcpy(sm, &ops, sizeof(*sm));
 	return r;
 }
 
-- 
1.8.1.4
