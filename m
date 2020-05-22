From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2] dm-zoned: remove leftover hunk for switching
	to sequential zones
Date: Fri, 22 May 2020 10:58:53 +0200
Message-ID: <20200522085853.123291-1-hare@suse.de>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Remove a leftover hunk to switch from random zones to sequential
zones when selecting a reclaim zone; the logic has moved into the
caller and this hunk is now pointless.

Fixes: 34f5affd04c4 ("dm zoned: separate random and cache zones")
Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index db0dc2b5d44d..4a2e351365c5 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -2111,14 +2111,6 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
 		 */
 		if (!(flags & DMZ_ALLOC_RECLAIM))
 			return NULL;
-		/*
-		 * Use sequential write zones if we started off with random
-		 * zones and the list is empty
-		 */
-		if (list == &zmd->unmap_rnd_list) {
-			list = &zmd->unmap_seq_list;
-			goto again;
-		}
 		/*
 		 * Fallback to the reserved sequential zones
 		 */
-- 
2.25.0
