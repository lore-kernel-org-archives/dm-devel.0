From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/11] dm-zoned: ignore metadata zone in
	dmz_alloc_zone()
Date: Mon,  6 Apr 2020 16:35:04 +0200
Message-ID: <20200406143505.133271-11-hare@suse.de>
References: <20200406143505.133271-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200406143505.133271-1-hare@suse.de>
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
---
 drivers/md/dm-zoned-metadata.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 6c52cbf290d5..e036ba4bfe57 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1910,7 +1910,13 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
 		zone = NULL;
 		goto again;
 	}
+	if (dmz_is_meta(zone)) {
+		struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
 
+		dmz_dev_warn(dev, "Zone %u has metadata", dmz_id(zmd, zone));
+		zone = NULL;
+		goto again;
+	}
 	return zone;
 }
 
-- 
2.25.0
