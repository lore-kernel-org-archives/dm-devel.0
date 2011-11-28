From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] DM RAID: Clean-up handling of 'rebuild' device
	requests
Date: Mon, 28 Nov 2011 14:01:05 -0600
Message-ID: <1322510465.20158.2.camel@f14.redhat.com>
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

dm-raid: Change the way the 'rebuild' parameter is processed.

1) We already allowed the rebuild flag to clear the superblock area for a
   device.  There is no reason to shame the user if they didn't clear the
   superblock area ahead of time.  Change the message to simply print-out
   that it is clearing the superblock for the purpose of a rebuild.
2) Set the 'FirstUse' flag in 'super_load' vs 'super_init_validation'.  This
   allows the devices that had 'rebuild' set to be processed like a new device.
3) Since the rebuild devices are processed like new devices, the MD_CHANGE_DEVS
   flag also gets set on the MD device.  This was a necessary missing action
   that forces the new superblock to be written when the array is instantiated.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -667,7 +667,14 @@ static int super_load(struct md_rdev *rd
 		return ret;
 
 	sb = page_address(rdev->sb_page);
-	if (sb->magic != cpu_to_le32(DM_RAID_MAGIC)) {
+
+	/*
+	 * Two cases that we want to write new superblocks and rebuild:
+	 * 1) New device (no matching magic number)
+	 * 2) Device specified for rebuild (!In_sync w/ offset == 0)
+	 */
+	if ((sb->magic != cpu_to_le32(DM_RAID_MAGIC)) ||
+	    (!test_bit(In_sync, &rdev->flags) && !rdev->recovery_offset)) {
 		super_sync(rdev->mddev, rdev);
 
 		set_bit(FirstUse, &rdev->flags);
@@ -743,12 +750,9 @@ static int super_init_validation(struct 
 	 *    recovery_cp must be MaxSector.
 	 */
 	rdev_for_each(r, t, mddev) {
-		if (!test_bit(In_sync, &r->flags)) {
-			if (!test_bit(FirstUse, &r->flags))
-				DMERR("Superblock area of "
-				      "rebuild device %d should have been "
-				      "cleared.", r->raid_disk);
-			set_bit(FirstUse, &r->flags);
+		if (!test_bit(In_sync, &r->flags))
+			DMINFO("Device %d specified for rebuild: "
+			       "Clearing superblock", r->raid_disk);
 			rebuilds++;
 		} else if (test_bit(FirstUse, &r->flags))
 			new_devs++;
