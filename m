From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] dm-zoned: invert zone check in
	dmz_reset_zone()
Date: Wed, 13 May 2020 09:07:28 +0200
Message-ID: <20200513070729.71461-2-hare@suse.de>
References: <20200513070729.71461-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200513070729.71461-1-hare@suse.de>
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

Instead of excluding invalid zones we should check if the zone
is sequential and exclude invalid states. That way we don't need
to touch the selection when new zone states or flags are added.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-zoned-metadata.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index d9e256762eff..9b93d7ff1dfc 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1570,12 +1570,16 @@ static int dmz_reset_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 	int ret;
 
 	/*
-	 * Ignore offline zones, read only zones,
-	 * and conventional zones.
+	 * Only check sequential zones.
+	 */
+	if (!dmz_is_seq(zone))
+		return 0;
+
+	/*
+	 * But ignore offline and read only zones.
 	 */
 	if (dmz_is_offline(zone) ||
-	    dmz_is_readonly(zone) ||
-	    dmz_is_rnd(zone))
+	    dmz_is_readonly(zone))
 		return 0;
 
 	if (!dmz_is_empty(zone) || dmz_seq_write_err(zone)) {
-- 
2.25.0
