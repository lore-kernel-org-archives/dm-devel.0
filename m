From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 2] dm-raid-add-md-raid1-support-2.patch
Date: Thu, 14 Jul 2011 16:23:30 -0500
Message-ID: <1310678610.2246.27.camel@f14.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Correct number of allowed "rebuild" devices in dm-raid

The number of devices that are allowed to be rebuilt in a RAID1
array is n - 1.  It is not limited by 'parity_devs' like the
other RAIDs.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -428,8 +428,12 @@ static int parse_raid_params(struct raid
 		}
 
 		if (!strcasecmp(key, "rebuild")) {
-			if (++rebuild_cnt > rs->raid_type->parity_devs) {
-				rs->ti->error = "Too many rebuild drives given";
+			rebuild_cnt++;
+			if (((rs->raid_type->level != 1) &&
+			     (rebuild_cnt > rs->raid_type->parity_devs)) ||
+			    ((rs->raid_type->level == 1) &&
+			     (rebuild_cnt > (rs->md.raid_disks - 1)))) {
+				rs->ti->error = "Too many rebuild devices specified for given RAID type";
 				return -EINVAL;
 			}
 			if (value > rs->md.raid_disks) {
