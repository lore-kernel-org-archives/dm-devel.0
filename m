From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 2] DM RAID: Restructure conditional
Date: Tue, 26 Jun 2012 03:59:44 -0500
Message-ID: <1340701184.19015.29.camel@f16>
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

dm-raid:  For code clarity, change 'if' conditional to 'switch' conditional

In preparation for RAID10 addition to dm-raid, we change an 'if' conditional
to a 'switch' conditional to make it easier to see what is being checked for
each RAID type.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -422,13 +422,26 @@ static int parse_raid_params(struct raid
 
 		if (!strcasecmp(key, "rebuild")) {
 			rebuild_cnt++;
-			if (((rs->raid_type->level != 1) &&
-			     (rebuild_cnt > rs->raid_type->parity_devs)) ||
-			    ((rs->raid_type->level == 1) &&
-			     (rebuild_cnt > (rs->md.raid_disks - 1)))) {
-				rs->ti->error = "Too many rebuild devices specified for given RAID type";
-				return -EINVAL;
+			rs->ti->error = NULL;
+
+			switch (rs->raid_type->level) {
+			case 1:
+				if (rebuild_cnt >= rs->md.raid_disks)
+					rs->ti->error = "Too many rebuild devices specified";
+				break;
+			case 4:
+			case 5:
+			case 6:
+				if (rebuild_cnt > rs->raid_type->parity_devs)
+					rs->ti->error = "Too many rebuild devices specified for given RAID type";
+				break;
+			default:
+				DMERR("The rebuild parameter is not supported for %s", rs->raid_type->name);
+				rs->ti->error = "Rebuild not supported for this RAID type";
 			}
+			if (rs->ti->error)
+				return -EINVAL;
+
 			if (value > rs->md.raid_disks) {
 				rs->ti->error = "Invalid rebuild index given";
 				return -EINVAL;
