From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH - v2] DM RAID: Use correct health status
 character when array is initializing and rebuilding devices
Date: Tue, 25 Oct 2011 10:27:38 -0500
Message-ID: <1319556458.4768.3.camel@f14.redhat.com>
References: <1316628846.8723.2.camel@f14.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1316628846.8723.2.camel@f14.redhat.com>
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

changes to previous:
1) When individual devices are being rebuilt, the other devices in the
array should be marked as "alive and in-sync", i.e. 'A'.

dm-raid: Device health characters of RAID arrays while sync'ing should be 'a'

When devices in a RAID array are not in-sync, they are supposed to be
reported as such in the status output via a 'a' character, which means
"alive, but not in-sync".  This was correct when rebuilding individual
devices, but not when the entire array was being built.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -1017,30 +1017,56 @@ static int raid_status(struct dm_target 
 	struct raid_set *rs = ti->private;
 	unsigned raid_param_cnt = 1; /* at least 1 for chunksize */
 	unsigned sz = 0;
-	int i;
+	int i, array_in_sync = 0;
 	sector_t sync;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
 		DMEMIT("%s %d ", rs->raid_type->name, rs->md.raid_disks);
 
-		for (i = 0; i < rs->md.raid_disks; i++) {
-			if (test_bit(Faulty, &rs->dev[i].rdev.flags))
-				DMEMIT("D");
-			else if (test_bit(In_sync, &rs->dev[i].rdev.flags))
-				DMEMIT("A");
-			else
-				DMEMIT("a");
-		}
-
 		if (test_bit(MD_RECOVERY_RUNNING, &rs->md.recovery))
 			sync = rs->md.curr_resync_completed;
 		else
 			sync = rs->md.recovery_cp;
 
-		if (sync > rs->md.resync_max_sectors)
+		if (sync >= rs->md.resync_max_sectors) {
+			array_in_sync = 1;
 			sync = rs->md.resync_max_sectors;
+		} else {
+			/*
+			 * The array may be doing an initial sync, or it may
+			 * be rebuilding individual components.  If all the
+			 * devices are In_sync, then it is the array that is
+			 * being initialized.
+			 */
+			for (i = 0; i < rs->md.raid_disks; i++)
+				if (!test_bit(In_sync, &rs->dev[i].rdev.flags))
+					array_in_sync = 1;
+		}
+		/*
+		 * Status characters:
+		 *  'D' = Dead/Failed device
+		 *  'a' = Alive but not in-sync
+		 *  'A' = Alive and in-sync
+		 */
+		for (i = 0; i < rs->md.raid_disks; i++) {
+			if (test_bit(Faulty, &rs->dev[i].rdev.flags))
+				DMEMIT("D");
+			else if (!array_in_sync ||
+				 !test_bit(In_sync, &rs->dev[i].rdev.flags))
+				DMEMIT("a");
+			else
+				DMEMIT("A");
+		}
 
+		/*
+		 * In-sync ratio:
+		 *  The in-sync ratio shows the progress of:
+		 *   - Initializing the array
+		 *   - Rebuilding a subset of devices of the array
+		 *  The user can distinguish between the two by referring
+		 *  to the status characters.
+		 */
 		DMEMIT(" %llu/%llu",
 		       (unsigned long long) sync,
 		       (unsigned long long) rs->md.resync_max_sectors);
