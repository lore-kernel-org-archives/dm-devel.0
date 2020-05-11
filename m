From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/15] dm-zoned: ignore metadata zone in
	dmz_alloc_zone()
Date: Mon, 11 May 2020 10:24:29 +0200
Message-ID: <20200511082430.39455-15-hare@suse.de>
References: <20200511082430.39455-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200511082430.39455-1-hare@suse.de>
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

When looking up zones in dmz_alloc_zone() we need to ignore
metadata zones so as not to accidentally overwrite metadata.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/md/dm-zoned-metadata.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 80c0fe4c3546..067ce010f457 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1907,7 +1907,13 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
 		zone = NULL;
 		goto again;
 	}
+	if (dmz_is_meta(zone)) {
+		struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
 
+		dmz_dev_warn(dev, "Zone %u has metadata", zone->id);
+		zone = NULL;
+		goto again;
+	}
 	return zone;
 }
 
-- 
2.16.4
