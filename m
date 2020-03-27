From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] dm-zoned: store zone id within the zone
	structure
Date: Fri, 27 Mar 2020 08:14:56 +0100
Message-ID: <20200327071459.67796-2-hare@suse.de>
References: <20200327071459.67796-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200327071459.67796-1-hare@suse.de>
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
Cc: Damien LeMoal <damien.lemoal@wdc.com>, Bob Liu <bob.liu@oracle.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Instead of calculating the zone index by the offset within the
zone array store the index within the structure itself.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-zoned-metadata.c | 3 ++-
 drivers/md/dm-zoned.h          | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index c8787560fa9f..afce594067fb 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -189,7 +189,7 @@ struct dmz_metadata {
  */
 unsigned int dmz_id(struct dmz_metadata *zmd, struct dm_zone *zone)
 {
-	return ((unsigned int)(zone - zmd->zones));
+	return zone->id;
 }
 
 sector_t dmz_start_sect(struct dmz_metadata *zmd, struct dm_zone *zone)
@@ -1119,6 +1119,7 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int idx, void *data)
 
 	INIT_LIST_HEAD(&zone->link);
 	atomic_set(&zone->refcount, 0);
+	zone->id = idx;
 	zone->chunk = DMZ_MAP_UNMAPPED;
 
 	switch (blkz->type) {
diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
index 884c0e586082..39d59898abbe 100644
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -87,6 +87,9 @@ struct dm_zone {
 	/* Zone activation reference count */
 	atomic_t		refcount;
 
+	/* Zone id */
+	unsigned int		id;
+
 	/* Zone write pointer block (relative to the zone start block) */
 	unsigned int		wp_block;
 
-- 
2.16.4
