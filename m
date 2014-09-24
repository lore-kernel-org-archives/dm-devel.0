From: heinzm@redhat.com
Subject: [PATCH 1/2] dm-raid: add RAID discard support
Date: Wed, 24 Sep 2014 16:12:57 +0200
Message-ID: <1411567978-16397-1-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Support discard in all RAID levels 1,10,4,5 and 6.

In case of RAID levels 4,5 and 6 we have to check for the capability
to zero data on discards to avoid stripe data corruption.

If that capabilizy is missing on any disk in a RAID set,
we have to disable discards.


Signed-off-by: Heinz Mauelshagen <heinzm|redhat.com>

---
 drivers/md/dm-raid.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4880b69..4edb2c7 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2010-2011 Neil Brown
- * Copyright (C) 2010-2011 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2010-2014 Red Hat, Inc. All rights reserved.
  *
  * This file is released under the GPL.
  */
@@ -1150,6 +1150,43 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 }
 
 /*
+ * Enable/disable discard support on RAID set depending
+ * on RAID level and discard properties of underlying devices
+ * (i.e. the legs of the set).
+ */
+static void raid_check_discard(struct dm_target *ti, struct raid_set *rs)
+{
+	int i;
+	bool discard_supported = true;
+	/* RAID level 4,5,6 request discard_zeroes_data for data integrity! */
+	bool raid1_or_10 = rs->md.level == 1 || rs->md.level == 10;
+	bool zeroes_data_mandatory = !raid1_or_10;
+
+	for (i = 0; i < rs->md.raid_disks; i++) {
+		struct request_queue *q = bdev_get_queue(rs->dev[i].rdev.bdev);
+
+		if (!q ||
+		    !blk_queue_discard(q) ||
+		    (zeroes_data_mandatory && !q->limits.discard_zeroes_data)) {
+			discard_supported = false;
+			break;
+		}
+	}
+
+	if (discard_supported) {
+		ti->discards_supported = true;
+		/*
+		 * raid1 and raid10 personalities require bio splitting,
+		 * raid4/5/6 don't and process large discard bios properly.
+		 */
+		ti->split_discard_bios = raid1_or_10;
+		ti->num_discard_bios = 1;
+
+	} else
+		ti->discards_supported = false;
+}
+
+/*
  * Construct a RAID4/5/6 mapping:
  * Args:
  *	<raid_type> <#raid_params> <raid_params>		\
@@ -1231,6 +1268,11 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	ti->private = rs;
 	ti->num_flush_bios = 1;
 
+	/*
+	 * Disable/enable discard support on RAID set.
+	 */
+	raid_check_discard(ti, rs);
+
 	mutex_lock(&rs->md.reconfig_mutex);
 	ret = md_run(&rs->md);
 	rs->md.in_sync = 0; /* Assume already marked dirty */
-- 
1.9.3
