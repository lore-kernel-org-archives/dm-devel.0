From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/14] dm-zoned: add debugging message for
	reading superblocks
Date: Fri, 29 May 2020 19:38:54 +0200
Message-ID: <20200529173907.40529-2-hare@suse.de>
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

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 4a2e351365c5..ef1524d5928a 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1105,6 +1105,10 @@ static int dmz_check_sb(struct dmz_metadata *zmd, unsigned int set)
  */
 static int dmz_read_sb(struct dmz_metadata *zmd, unsigned int set)
 {
+	dmz_zmd_debug(zmd, "read superblock set %d dev %s block %llu",
+		      set, zmd->sb[set].dev->name,
+		      zmd->sb[set].block);
+
 	return dmz_rdwr_block(zmd->sb[set].dev, REQ_OP_READ,
 			      zmd->sb[set].block, zmd->sb[set].mblk->page);
 }
-- 
2.16.4
