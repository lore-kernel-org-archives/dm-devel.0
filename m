From: jbrassow@ovpn-117-28.phx2.redhat.com (Jonathan Brassow)
Subject: [PATCH 1 of 2] DM RAID:  variable cleanup
Date: Mon,  2 Oct 2017 17:17:35 -0500 (CDT)
Message-ID: <20171002221735.518CA1A4716A@ovpn-117-28.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: -c@ovpn-117-28.phx2.redhat.com, dm-devel@redhat.com, heinzm@redhat.com
List-Id: dm-devel.ids

Patch name: dm-raid-variable-cleanup.patch

dm-raid: remove unneeded intermediate variable

No reason to have extra intermediate variable 'recovery_cp'.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -3297,11 +3297,10 @@ static const char *__raid_dev_status(str
 static sector_t rs_get_progress(struct raid_set *rs,
 				sector_t resync_max_sectors, bool *array_in_sync)
 {
-	sector_t r, recovery_cp, curr_resync_completed;
+	sector_t r, curr_resync_completed;
 	struct mddev *mddev = &rs->md;
 
 	curr_resync_completed = mddev->curr_resync_completed ?: mddev->recovery_cp;
-	recovery_cp = mddev->recovery_cp;
 	*array_in_sync = false;
 
 	if (rs_is_raid0(rs)) {
@@ -3330,7 +3329,7 @@ static sector_t rs_get_progress(struct r
 		} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 			r = curr_resync_completed;
 		else
-			r = recovery_cp;
+			r = mddev->recovery_cp;
 
 		if (r == MaxSector) {
 			/*
