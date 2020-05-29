From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/14] dm-zoned: secondary superblock must reside
	on the same devices than primary superblock
Date: Fri, 29 May 2020 19:38:55 +0200
Message-ID: <20200529173907.40529-3-hare@suse.de>
References: <20200529173907.40529-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200529173907.40529-1-hare@suse.de>
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

The secondary superblock must reside on the same device than the
primary superblock, so there's no need to re-calculate the device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index ef1524d5928a..043ed882970a 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1135,7 +1135,7 @@ static int dmz_lookup_secondary_sb(struct dmz_metadata *zmd)
 	/* Bad first super block: search for the second one */
 	zmd->sb[1].block = zmd->sb[0].block + zone_nr_blocks;
 	zmd->sb[1].zone = zmd->sb[0].zone + 1;
-	zmd->sb[1].dev = dmz_zone_to_dev(zmd, zmd->sb[1].zone);
+	zmd->sb[1].dev = zmd->sb[0].dev;
 	for (i = 0; i < zmd->nr_rnd_zones - 1; i++) {
 		if (dmz_read_sb(zmd, 1) != 0)
 			break;
@@ -1144,7 +1144,6 @@ static int dmz_lookup_secondary_sb(struct dmz_metadata *zmd)
 			return 0;
 		}
 		zmd->sb[1].block += zone_nr_blocks;
-		zmd->sb[1].dev = dmz_zone_to_dev(zmd, zmd->sb[1].zone + i);
 	}
 
 	dmz_free_mblock(zmd, mblk);
@@ -1263,7 +1262,7 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
 		if (!zmd->sb[1].zone)
 			zmd->sb[1].zone = zmd->sb[0].zone + zmd->nr_meta_zones;
 		zmd->sb[1].block = dmz_start_block(zmd, zmd->sb[1].zone);
-		zmd->sb[1].dev = dmz_zone_to_dev(zmd, zmd->sb[1].zone);
+		zmd->sb[1].dev = zmd->sb[0].dev;
 		ret = dmz_get_sb(zmd, 1);
 	} else
 		ret = dmz_lookup_secondary_sb(zmd);
-- 
2.16.4
