From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/15] dm-zoned: improve logging messages for
	reclaim
Date: Wed, 27 May 2020 08:22:13 +0200
Message-ID: <20200527062225.72849-4-hare@suse.de>
References: <20200527062225.72849-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200527062225.72849-1-hare@suse.de>
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

Instead of just reporting the errno this patch adds some more
verbose debugging message in the reclaim path.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-reclaim.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index 571bc1d41bab..fd4d47dfcea1 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -371,8 +371,11 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
 
 	/* Get a data zone */
 	dzone = dmz_get_zone_for_reclaim(zmd, dmz_target_idle(zrc));
-	if (!dzone)
+	if (!dzone) {
+		DMDEBUG("(%s): No zone found to reclaim",
+			dmz_metadata_label(zmd));
 		return -EBUSY;
+	}
 
 	start = jiffies;
 	if (dmz_is_cache(dzone) || dmz_is_rnd(dzone)) {
@@ -416,6 +419,12 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
 	}
 out:
 	if (ret) {
+		if (ret == -EINTR)
+			DMDEBUG("(%s): reclaim zone %u interrupted",
+				dmz_metadata_label(zmd), rzone->id);
+		else
+			DMDEBUG("(%s): Failed to reclaim zone %u, err %d",
+				dmz_metadata_label(zmd), rzone->id, ret);
 		dmz_unlock_zone_reclaim(dzone);
 		return ret;
 	}
@@ -519,8 +528,6 @@ static void dmz_reclaim_work(struct work_struct *work)
 
 	ret = dmz_do_reclaim(zrc);
 	if (ret && ret != -EINTR) {
-		DMDEBUG("(%s): Reclaim error %d",
-			dmz_metadata_label(zmd), ret);
 		if (!dmz_check_dev(zmd))
 			return;
 	}
-- 
2.16.4
