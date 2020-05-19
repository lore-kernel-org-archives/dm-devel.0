From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/6] dm-zoned: remove unused variable in
	dmz_do_reclaim()
Date: Tue, 19 May 2020 10:14:24 +0200
Message-ID: <20200519081424.103318-7-hare@suse.de>
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

'dev' is unused, and can be removed.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-zoned-reclaim.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index 3ed88581dc48..571bc1d41bab 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -366,7 +366,6 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
 	struct dmz_metadata *zmd = zrc->metadata;
 	struct dm_zone *dzone;
 	struct dm_zone *rzone;
-	struct dmz_dev *dev;
 	unsigned long start;
 	int ret;
 
@@ -376,7 +375,6 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
 		return -EBUSY;
 
 	start = jiffies;
-	dev = dmz_zone_to_dev(zmd, dzone);
 	if (dmz_is_cache(dzone) || dmz_is_rnd(dzone)) {
 		if (!dmz_weight(dzone)) {
 			/* Empty zone */
-- 
2.16.4
