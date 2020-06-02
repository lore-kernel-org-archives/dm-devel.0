From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/15] dm-zoned: check superblock location
Date: Tue,  2 Jun 2020 13:09:56 +0200
Message-ID: <20200602110956.121170-16-hare@suse.de>
References: <20200602110956.121170-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200602110956.121170-1-hare@suse.de>
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

When specifying several devices we need to check the superblock
location to ensure the devices are specified in the correct order.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-zoned-metadata.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index e01ca1c57ff2..bf54c5d90095 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -995,7 +995,7 @@ static int dmz_check_sb(struct dmz_metadata *zmd, struct dmz_sb *dsb,
 	struct dmz_dev *dev = dsb->dev;
 	unsigned int nr_meta_zones, nr_data_zones;
 	u32 crc, stored_crc;
-	u64 gen;
+	u64 gen, sb_block;
 
 	if (le32_to_cpu(sb->magic) != DMZ_MAGIC) {
 		dmz_dev_err(dev, "Invalid meta magic (needed 0x%08x, got 0x%08x)",
@@ -1024,6 +1024,14 @@ static int dmz_check_sb(struct dmz_metadata *zmd, struct dmz_sb *dsb,
 		return -ENXIO;
 	}
 
+	sb_block = le64_to_cpu(sb->sb_block);
+	if (sb_block != (u64)dsb->zone->id << zmd->zone_nr_blocks_shift ) {
+		dmz_dev_err(dev, "Invalid superblock position "
+			    "(is %llu expected %llu)",
+			    sb_block,
+			    (u64)dsb->zone->id << zmd->zone_nr_blocks_shift);
+		return -EINVAL;
+	}
 	if (zmd->sb_version > 1) {
 		uuid_t sb_uuid;
 
-- 
2.16.4
