From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/6] dm-zoned: start reclaim with sequential zones
Date: Tue, 19 May 2020 10:14:22 +0200
Message-ID: <20200519081424.103318-5-hare@suse.de>
References: <20200519081424.103318-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200519081424.103318-1-hare@suse.de>
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

Sequential zones perform better for reclaim, so start off using
them and only use random zones as a fallback when cache zones are
present.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-zoned-reclaim.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index 1855c056d6a4..1283405bec29 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -281,15 +281,16 @@ static int dmz_reclaim_rnd_data(struct dmz_reclaim *zrc, struct dm_zone *dzone)
 	struct dm_zone *szone = NULL;
 	struct dmz_metadata *zmd = zrc->metadata;
 	int ret;
-	int alloc_flags = dmz_nr_cache_zones(zmd) ?
-		DMZ_ALLOC_RND : DMZ_ALLOC_SEQ;
+	int alloc_flags = DMZ_ALLOC_SEQ;
 
-	/* Always use sequential zones to reclaim random zones */
-	if (dmz_is_rnd(dzone))
-		alloc_flags = DMZ_ALLOC_SEQ;
 	/* Get a free random or sequential zone */
 	dmz_lock_map(zmd);
+again:
 	szone = dmz_alloc_zone(zmd, alloc_flags | DMZ_ALLOC_RECLAIM);
+	if (!szone && alloc_flags == DMZ_ALLOC_SEQ && dmz_nr_cache_zones(zmd)) {
+		alloc_flags = DMZ_ALLOC_RND;
+		goto again;
+	}
 	dmz_unlock_map(zmd);
 	if (!szone)
 		return -ENOSPC;
-- 
2.16.4
